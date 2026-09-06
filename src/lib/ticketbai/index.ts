import "server-only";
import type { SupabaseClient } from "@supabase/supabase-js";
import { construirIdentificativoTbai } from "@/lib/ticketbai/identificador";
import { construirUrlQrTbai } from "@/lib/ticketbai/qr";
import { construirXmlFacturaTicketBai } from "@/lib/ticketbai/xml";
import { getFirmanteTicketBai } from "@/lib/ticketbai/firma";
import type { DatosFacturaTicketBai, DesgloseIvaTicketBai, LineaFacturaTicketBai } from "@/lib/ticketbai/types";

interface LineaCruda {
  descripcion: string;
  cantidad: number;
  importe_unitario_centimos: number;
  importe_total_centimos: number;
  tipo_impositivo: number;
}

interface FilaFacturaTicketBai {
  id: string;
  serie: string;
  numero: number;
  fecha_expedicion: string;
  identificativo_tbai: string | null;
  qr_url: string | null;
  estado: string;
  encadenamiento_serie_anterior: string | null;
  encadenamiento_numero_anterior: number | null;
  encadenamiento_fecha_anterior: string | null;
  encadenamiento_firma_anterior: string | null;
}

export interface ResultadoEmisionTicketBai {
  /** false si TICKETBAI_ENABLED no es "true": no se ha intentado nada, comportamiento actual sin cambios. */
  habilitado: boolean;
  /** true si esta factura ya se había emitido antes (p.ej. "Imprimir cuenta" pulsado dos veces) — el ticket debe marcarse como duplicado. */
  duplicado: boolean;
  identificativoTbai: string | null;
  qrUrl: string | null;
  /** Presente si se intentó emitir pero falló (falta certificado, XML inválido, etc.) — no debe bloquear la impresión del ticket normal. */
  error: string | null;
}

const SIN_EMITIR: ResultadoEmisionTicketBai = {
  habilitado: false,
  duplicado: false,
  identificativoTbai: null,
  qrUrl: null,
  error: null,
};

function leerConfiguracion() {
  return {
    // "WEB" por defecto — confirmado que el TPV físico actual usa la serie "FSE11", así que
    // este sistema necesita una distinta (ver .env.example para el porqué).
    serie: process.env.TICKETBAI_SERIE ?? "WEB",
    licenciaTbai: process.env.TICKETBAI_LICENCIA ?? "",
    nifEntidadDesarrolladora: process.env.TICKETBAI_ENTIDAD_DESARROLLADORA_NIF ?? "",
    softwareNombre: process.env.TICKETBAI_SOFTWARE_NOMBRE ?? "La Osa TPV",
    softwareVersion: process.env.TICKETBAI_SOFTWARE_VERSION ?? "1.0",
  };
}

function agruparPorTipoIva(lineas: LineaCruda[]): DesgloseIvaTicketBai[] {
  const grupos = new Map<number, { baseCentimos: number; cuotaCentimos: number }>();

  for (const linea of lineas) {
    // importe_total_centimos ya incluye IVA (mismo criterio que el resto de la app,
    // ver ImporteTotalFactura/ImporteTotal en src/lib/ticketbai/xml.ts).
    const totalConIva = linea.importe_total_centimos;
    const baseCentimos = Math.round(totalConIva / (1 + linea.tipo_impositivo / 100));
    const cuotaCentimos = totalConIva - baseCentimos;

    const acumulado = grupos.get(linea.tipo_impositivo) ?? { baseCentimos: 0, cuotaCentimos: 0 };
    grupos.set(linea.tipo_impositivo, {
      baseCentimos: acumulado.baseCentimos + baseCentimos,
      cuotaCentimos: acumulado.cuotaCentimos + cuotaCentimos,
    });
  }

  return Array.from(grupos.entries())
    .sort(([a], [b]) => a - b)
    .map(([tipoImpositivo, { baseCentimos, cuotaCentimos }]) => ({
      tipoImpositivo,
      baseImponibleCentimos: baseCentimos,
      cuotaCentimos,
    }));
}

function filaADatosFactura(
  fila: FilaFacturaTicketBai,
  lineas: LineaFacturaTicketBai[],
  desgloseIva: DesgloseIvaTicketBai[],
  importeTotalCentimos: number,
  nifEmisor: string,
  razonSocialEmisor: string,
  descripcion: string,
  config: ReturnType<typeof leerConfiguracion>,
): DatosFacturaTicketBai {
  return {
    serieFactura: fila.serie,
    numFactura: String(fila.numero),
    fechaExpedicion: new Date(`${fila.fecha_expedicion}T12:00:00`),
    nifEmisor,
    nombreRazonSocialEmisor: razonSocialEmisor,
    descripcionFactura: descripcion,
    facturaSimplificada: true,
    importeTotalFacturaCentimos: importeTotalCentimos,
    lineas,
    desgloseIva,
    encadenamientoAnterior:
      fila.encadenamiento_serie_anterior && fila.encadenamiento_numero_anterior != null && fila.encadenamiento_fecha_anterior && fila.encadenamiento_firma_anterior
        ? {
            serieFactura: fila.encadenamiento_serie_anterior,
            numFactura: String(fila.encadenamiento_numero_anterior),
            fechaExpedicion: new Date(`${fila.encadenamiento_fecha_anterior}T12:00:00`),
            firma: fila.encadenamiento_firma_anterior,
          }
        : null,
    software: {
      licenciaTbai: config.licenciaTbai,
      nifEntidadDesarrolladora: config.nifEntidadDesarrolladora,
      nombre: config.softwareNombre,
      version: config.softwareVersion,
    },
  };
}

/**
 * Punto de entrada único: genera (o recupera, si ya existía) la factura TicketBAI de un
 * conjunto de pedidos. No hace nada si TICKETBAI_ENABLED no es "true" — hasta que el negocio
 * tenga certificado digital y número de alta-inscripción TBAI, esto es un no-op y el
 * ticket se imprime exactamente igual que hoy (ver src/lib/print/ticket.ts).
 */
export async function emitirFacturaTicketBai(
  supabase: SupabaseClient,
  input: {
    clienteId: string;
    mesaId: string;
    pedidoIds: string[];
    nifEmisor: string;
    razonSocialEmisor: string;
    descripcion?: string;
  },
): Promise<ResultadoEmisionTicketBai> {
  if (process.env.TICKETBAI_ENABLED !== "true") {
    return SIN_EMITIR;
  }

  const config = leerConfiguracion();

  const { data: existente, error: errorBusqueda } = await supabase.rpc(
    "buscar_factura_ticketbai_por_pedidos",
    { p_cliente_id: input.clienteId, p_pedido_ids: input.pedidoIds },
  );
  if (errorBusqueda) {
    return { ...SIN_EMITIR, habilitado: true, error: errorBusqueda.message };
  }
  // buscar_factura_ticketbai_por_pedidos devuelve jsonb: un objeto único o null, no un array.
  const filaExistente = existente as FilaFacturaTicketBai | null;
  if (filaExistente) {
    return {
      habilitado: true,
      duplicado: true,
      identificativoTbai: filaExistente.identificativo_tbai,
      qrUrl: filaExistente.qr_url,
      error: null,
    };
  }

  const { data: lineasCrudas, error: errorLineas } = await supabase.rpc("get_lineas_factura_ticketbai", {
    p_cliente_id: input.clienteId,
    p_pedido_ids: input.pedidoIds,
  });
  if (errorLineas) {
    return { ...SIN_EMITIR, habilitado: true, error: errorLineas.message };
  }
  const lineas = (lineasCrudas as LineaCruda[] | null) ?? [];
  if (lineas.length === 0) {
    return { ...SIN_EMITIR, habilitado: true, error: "No hay líneas de pedido para facturar" };
  }

  const importeTotalCentimos = lineas.reduce((sum, l) => sum + l.importe_total_centimos, 0);
  const desgloseIva = agruparPorTipoIva(lineas);
  // get_lineas_factura_ticketbai ya aplica la regla de tipo_impositivo (10/21 según
  // alcohol_pct) en el propio SQL — ver src/lib/ticketbai/tipo-iva.ts para la misma regla
  // documentada y reutilizable en el lado del cliente (impresión del ticket).
  const lineasFactura: LineaFacturaTicketBai[] = lineas.map((l) => ({
    descripcion: l.descripcion,
    cantidad: l.cantidad,
    importeUnitarioCentimos: l.importe_unitario_centimos,
    importeTotalCentimos: l.importe_total_centimos,
    tipoImpositivo: l.tipo_impositivo,
  }));

  // crear_factura_ticketbai devuelve una única fila compuesta (no SETOF), PostgREST ya la
  // entrega como objeto, no como array — no hace falta (ni funciona bien) encadenar .single().
  const { data: filaCreada, error: errorCrear } = await supabase.rpc("crear_factura_ticketbai", {
    p_cliente_id: input.clienteId,
    p_pedido_ids: input.pedidoIds,
    p_mesa_id: input.mesaId,
    p_serie: config.serie,
    p_nif_emisor: input.nifEmisor,
    p_razon_social_emisor: input.razonSocialEmisor,
    p_descripcion: input.descripcion ?? "Consumición hostelería",
    p_importe_total_centimos: importeTotalCentimos,
    p_desglose_iva: desgloseIva,
    p_lineas: lineasFactura,
  });
  if (errorCrear || !filaCreada) {
    return { ...SIN_EMITIR, habilitado: true, error: errorCrear?.message ?? "No se pudo crear la factura" };
  }
  const fila = filaCreada as FilaFacturaTicketBai;

  const datosFactura = filaADatosFactura(
    fila,
    lineasFactura,
    desgloseIva,
    importeTotalCentimos,
    input.nifEmisor,
    input.razonSocialEmisor,
    input.descripcion ?? "Consumición hostelería",
    config,
  );
  const xmlSinFirmar = construirXmlFacturaTicketBai(datosFactura);

  try {
    const firmante = getFirmanteTicketBai();
    const { xmlFirmado, signatureValue } = await firmante.firmar(xmlSinFirmar);

    const identificativoTbai = construirIdentificativoTbai({
      nifEmisor: input.nifEmisor,
      fechaExpedicion: datosFactura.fechaExpedicion,
      signatureValue,
    });
    const qrUrl = construirUrlQrTbai({
      identificativoTbai,
      serieFactura: fila.serie,
      numFactura: String(fila.numero),
      importeTotalFacturaCentimos: importeTotalCentimos,
    });

    await supabase.rpc("actualizar_factura_ticketbai", {
      p_id: fila.id,
      p_estado: "FIRMADA",
      p_identificativo_tbai: identificativoTbai,
      p_qr_url: qrUrl,
      p_xml_sin_firmar: xmlSinFirmar,
      p_xml_firmado: xmlFirmado,
      p_signature_value: signatureValue,
    });

    // Envío a Batuz/LROE: no implementado todavía (ver src/lib/ticketbai/envio.ts). La
    // factura queda FIRMADA pero no ENVIADA — limitación conocida, hay que completarla
    // antes de operar en producción real.

    return { habilitado: true, duplicado: false, identificativoTbai, qrUrl, error: null };
  } catch (err) {
    const mensaje = err instanceof Error ? err.message : "Error desconocido firmando la factura TicketBAI";
    await supabase.rpc("actualizar_factura_ticketbai", {
      p_id: fila.id,
      p_estado: "ERROR",
      p_xml_sin_firmar: xmlSinFirmar,
      p_error_mensaje: mensaje,
    });
    return { habilitado: true, duplicado: false, identificativoTbai: null, qrUrl: null, error: mensaje };
  }
}
