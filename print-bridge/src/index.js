import "dotenv/config";
import { execFile } from "node:child_process";
import { writeFile, unlink } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { createClient } from "@supabase/supabase-js";
import { ThermalPrinter, PrinterTypes } from "node-thermal-printer";

const SUPABASE_URL = process.env.SUPABASE_URL;
const SUPABASE_ANON_KEY = process.env.SUPABASE_ANON_KEY;
const BRIDGE_EMAIL = process.env.BRIDGE_EMAIL;
const BRIDGE_PASSWORD = process.env.BRIDGE_PASSWORD;
const PRINTER_COCINA_INTERFACE = process.env.PRINTER_COCINA_INTERFACE;
const PRINTER_BARRA_PUERTO_WINDOWS = process.env.PRINTER_BARRA_PUERTO_WINDOWS;

if (
  !SUPABASE_URL ||
  !SUPABASE_ANON_KEY ||
  !BRIDGE_EMAIL ||
  !BRIDGE_PASSWORD ||
  !PRINTER_COCINA_INTERFACE ||
  !PRINTER_BARRA_PUERTO_WINDOWS
) {
  console.error("Faltan variables de entorno. Copia .env.example a .env y rellénalo.");
  process.exit(1);
}

const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

const printerCocina = new ThermalPrinter({
  type: PrinterTypes.EPSON,
  interface: PRINTER_COCINA_INTERFACE,
  width: 42,
  removeSpecialCharacters: false,
  options: { timeout: 5000 },
});

// La impresora de barra va por USB directo al PC de la TPV, sin IP: se
// construye el ticket en memoria con node-thermal-printer (que no necesita
// tocar la interfaz para eso) y se envía en crudo al puerto de Windows con
// "copy /b", que es lo que entienden los drivers genéricos tipo PrinterPOS-80.
const printerBarra = new ThermalPrinter({
  type: PrinterTypes.EPSON,
  interface: "tcp://127.0.0.1:9100", // no se usa para conectar, solo para construir el ticket
  width: 42,
  removeSpecialCharacters: false,
});

async function imprimirEnPuertoWindows(buffer, puerto) {
  const archivoTemp = join(tmpdir(), `ticket-${Date.now()}-${Math.random().toString(16).slice(2)}.prn`);
  await writeFile(archivoTemp, buffer);
  try {
    await new Promise((resolve, reject) => {
      execFile("cmd", ["/c", "copy", "/b", archivoTemp, puerto], (err, _stdout, stderr) => {
        if (err) reject(new Error(stderr || err.message));
        else resolve();
      });
    });
  } finally {
    await unlink(archivoTemp).catch(() => {});
  }
}

const impresosCocina = new Set();
const impresosBarra = new Set();

function formatFechaHora() {
  return new Date().toLocaleString("es-ES", { timeZone: "Europe/Madrid" });
}

function construirTicketComanda(printer, pedido, items, etiquetaDestino) {
  printer.clear();
  printer.alignCenter();
  printer.bold(true);
  printer.println("PALOMITA BAR");
  printer.bold(false);
  printer.drawLine();

  printer.alignLeft();
  printer.setTextNormal();
  printer.println(formatFechaHora());
  printer.bold(true);
  printer.println(
    `Mesa: ${pedido.mesa_numero ?? "-"}${pedido.mesa_nombre ? ` · ${pedido.mesa_nombre}` : ""}`,
  );
  printer.bold(false);
  if (pedido.participante_nombre) printer.println(`Pedido de ${pedido.participante_nombre}`);
  if (pedido.notas) printer.println(`Notas: ${pedido.notas}`);

  printer.newLine();
  printer.alignCenter();
  printer.setTextDoubleHeight();
  printer.bold(true);
  printer.println(`* ${etiquetaDestino} *`);
  printer.bold(false);
  printer.setTextNormal();
  printer.alignLeft();
  printer.drawLine();

  for (const item of items) {
    printer.bold(true);
    printer.println(`[${item.cantidad}] ${item.producto_nombre}`);
    printer.bold(false);
    if (item.notas) printer.println(`     ↳ ${item.notas}`);
  }

  printer.drawLine();
  printer.alignCenter();
  printer.setTextNormal();
  printer.println(`${items.reduce((n, i) => n + i.cantidad, 0)} producto(s)`);
  printer.alignLeft();

  printer.newLine();
  printer.cut();
}

/** Una estación (comida o bebida) está lista para imprimirse cuando alguien
 * ya la ha aceptado, es decir, ninguna de sus líneas activas sigue en
 * RECIBIDO. Las líneas canceladas no cuentan (no bloquean ni disparan nada). */
function estacionAceptada(items) {
  const activos = items.filter((item) => item.estado !== "CANCELLED");
  return activos.length > 0 && activos.every((item) => item.estado !== "RECEIVED");
}

function itemsPorEstacion(pedido) {
  const items = pedido.items ?? [];
  return {
    comida: items.filter((item) => item.producto_tipo !== "bebida"),
    bebida: items.filter((item) => item.producto_tipo === "bebida"),
  };
}

async function imprimirComandaCocina(pedido, itemsCocina) {
  try {
    construirTicketComanda(printerCocina, pedido, itemsCocina, "COCINA");
    await printerCocina.execute();
    console.log(`[OK] Comanda COCINA impresa · pedido ${pedido.id} · mesa ${pedido.mesa_numero ?? "-"}`);
  } catch (err) {
    console.error(`[ERROR] No se pudo imprimir en COCINA el pedido ${pedido.id}:`, err.message);
  }
}

async function imprimirComandaBarra(pedido, itemsBarra) {
  try {
    construirTicketComanda(printerBarra, pedido, itemsBarra, "BARRA");
    const buffer = printerBarra.getBuffer();
    await imprimirEnPuertoWindows(buffer, PRINTER_BARRA_PUERTO_WINDOWS);
    console.log(`[OK] Comanda BARRA impresa · pedido ${pedido.id} · mesa ${pedido.mesa_numero ?? "-"}`);
  } catch (err) {
    console.error(`[ERROR] No se pudo imprimir en BARRA el pedido ${pedido.id}:`, err.message);
  }
}

// Imprime cada estación (comida/bebida) la primera vez que se detecta
// aceptada — tanto si se aceptó el pedido entero de golpe desde "Todos"
// (mixto o no) como si se aceptó solo su estación desde "Cocina"/"Barra".
async function revisarPedidosPendientes() {
  const { data, error } = await supabase.rpc("get_pedidos_cocina");
  if (error) {
    console.error("[ERROR] get_pedidos_cocina:", error.message);
    return;
  }

  for (const pedido of data ?? []) {
    const { comida, bebida } = itemsPorEstacion(pedido);

    if (!impresosCocina.has(pedido.id) && estacionAceptada(comida)) {
      impresosCocina.add(pedido.id);
      await imprimirComandaCocina(pedido, comida);
    }
    if (!impresosBarra.has(pedido.id) && estacionAceptada(bebida)) {
      impresosBarra.add(pedido.id);
      await imprimirComandaBarra(pedido, bebida);
    }
  }
}

async function main() {
  console.log("Iniciando sesión en Supabase...");
  const { error: authError } = await supabase.auth.signInWithPassword({
    email: BRIDGE_EMAIL,
    password: BRIDGE_PASSWORD,
  });
  if (authError) {
    console.error("No se pudo iniciar sesión:", authError.message);
    process.exit(1);
  }
  console.log("Sesión iniciada.");

  const conectadaCocina = await printerCocina.isPrinterConnected().catch(() => false);
  console.log(
    conectadaCocina
      ? "Impresora de COCINA conectada."
      : "Aviso: no se pudo confirmar la conexión con la impresora de COCINA (se intentará imprimir igualmente).",
  );
  console.log(`Impresora de BARRA configurada en el puerto Windows "${PRINTER_BARRA_PUERTO_WINDOWS}" (no se comprueba conexión de antemano).`);

  // No reimprimir estaciones que ya estuvieran aceptadas antes de arrancar el
  // servicio; las que sigan esperando aceptación se imprimirán en cuanto se acepten.
  const { data: existentes } = await supabase.rpc("get_pedidos_cocina");
  for (const pedido of existentes ?? []) {
    const { comida, bebida } = itemsPorEstacion(pedido);
    if (estacionAceptada(comida)) impresosCocina.add(pedido.id);
    if (estacionAceptada(bebida)) impresosBarra.add(pedido.id);
  }
  console.log(`Listo. ${(existentes ?? []).length} pedido(s) existentes revisados.`);
  console.log("Esperando aceptaciones...");

  const channel = supabase
    .channel("cocina-print-bridge")
    .on(
      "postgres_changes",
      { event: "INSERT", schema: "restaurant", table: "pedidos" },
      () => revisarPedidosPendientes(),
    )
    .on(
      "postgres_changes",
      { event: "UPDATE", schema: "restaurant", table: "pedidos" },
      () => revisarPedidosPendientes(),
    )
    .on(
      "postgres_changes",
      { event: "*", schema: "restaurant", table: "pedido_items" },
      () => revisarPedidosPendientes(),
    )
    .subscribe((status) => console.log("Canal Realtime:", status));

  process.on("SIGINT", () => {
    supabase.removeChannel(channel);
    process.exit(0);
  });
}

main();
