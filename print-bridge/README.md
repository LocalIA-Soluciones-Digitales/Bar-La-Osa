# Print bridge — comanda automática de cocina y barra

Servicio local (Node.js) que se queda escuchando los pedidos de La Osa
en Supabase y, en cuanto **se acepta** una comanda (botón "Aceptar" en
`/admin/cocina`, desde la pestaña "Todos", "Cocina" o "Barra"), imprime
automáticamente cada estación en su impresora, sin que nadie tenga que darle
a ningún botón de imprimir:

- **COCINA** (impresora en red, IP fija): solo los productos de comida, en
  cuanto la estación de comida queda aceptada.
- **BARRA** (impresora "TICKET", por USB en el propio PC de la TPV): solo
  los productos de bebida, en cuanto la estación de bebida queda aceptada.

Ojo: no imprime al **crear** el pedido, sino al **aceptarlo** — así cocina/
barra no ven un ticket hasta que alguien ha confirmado que lo va a preparar.
Si un pedido mezcla comida y bebida y se acepta entero de una vez desde la
pestaña "Todos", salen los dos tickets a la vez; si cada estación se acepta
por separado (pestañas "Cocina"/"Barra"), cada ticket sale en el momento en
que se acepta su propia estación.

Los botones "Imprimir comanda"/"Imprimir cuenta" de `/admin/mesas` y
`/admin/barra`, y "Reimprimir comanda" en `/admin/cocina`, siguen existiendo
aparte (imprimen a mano, vía el navegador) para reimprimir algo puntual —
para el día a día, con este servicio corriendo ya no hace falta usarlos.

Es un proceso aparte de la web (la web vive en Vercel y no puede hablar con
las impresoras de la red del bar). Este servicio se ejecuta en el propio PC
de la TPV, porque es el que tiene la impresora de barra conectada por USB;
desde ahí también llega por red a la impresora de cocina.

## 1. Requisitos

- Node.js 18 o superior instalado en el PC de la TPV (es el que corre este
  servicio, porque es el que tiene la impresora de barra por USB).
- Impresora de **COCINA** accesible por LAN con IP fija y puerto `9100`
  (estándar ESC/POS en crudo). Se configura con la utilidad de red que trae
  el fabricante ("LAN Cable / NetPrint Config" o similar).
- Impresora de **BARRA** instalada en Windows como impresora normal, por USB
  (driver genérico tipo "PrinterPOS-80" o el que traiga). Necesitas el
  nombre del **puerto** (no el nombre de la impresora): en
  *Impresoras y escáneres → [la impresora] → Propiedades → Puertos*, mira
  cuál está marcado (ej. `USB001`).
- Una cuenta de acceso a `/admin` dedicada a este servicio (recomendado:
  crear una específica, no reutilizar la personal, así se puede revocar sin
  afectar a nadie).

## 2. Instalación

```bash
cd print-bridge
npm install
cp .env.example .env
```

Rellena `.env`:
- `SUPABASE_URL` / `SUPABASE_ANON_KEY`: los mismos valores que
  `NEXT_PUBLIC_SUPABASE_URL` / `NEXT_PUBLIC_SUPABASE_ANON_KEY` en el
  `.env.local` de la web.
- `BRIDGE_EMAIL` / `BRIDGE_PASSWORD`: la cuenta de acceso a `/admin` de este
  servicio.
- `PRINTER_COCINA_INTERFACE`: `tcp://<ip-impresora-cocina>:9100`.
- `PRINTER_BARRA_PUERTO_WINDOWS`: el nombre del puerto Windows de la
  impresora de barra (ej. `USB001`).

## 3. Arrancar

```bash
npm start
```

Deja este proceso corriendo. En consola verás cada comanda impresa:

```
[OK] Comanda COCINA impresa · pedido 3fa2... · mesa 4
[OK] Comanda BARRA impresa · pedido 3fa2... · mesa 4
```

Al arrancar, el servicio marca como "ya vistos" los pedidos que ya estuvieran
en cola en ese momento (no los reimprime); solo imprime lo que llegue **a
partir de ese momento**, tanto si el pedido lo mete el encargado a mano en
`/admin/mesas` o `PedidoRapidoForm` como si lo hace un cliente desde
`/pedir` (gestión online).

## 4. Dejarlo funcionando siempre (arranque con Windows)

Para que no dependa de tener una ventana de consola abierta y sobreviva a
reinicios del PC, la forma más sencilla es con [NSSM](https://nssm.cc/):

```powershell
nssm install LaOsaPrintBridge "C:\Program Files\nodejs\node.exe" "C:\ruta\a\print-bridge\src\index.js"
nssm set LaOsaPrintBridge AppDirectory "C:\ruta\a\print-bridge"
nssm start LaOsaPrintBridge
```

Esto lo registra como servicio de Windows: arranca solo al encender el PC y
se reinicia si falla.

## 5. Solución de problemas

- **"No se pudo confirmar la conexión con la impresora de COCINA"**: revisa
  que la IP y el puerto en `PRINTER_COCINA_INTERFACE` sean correctos y que
  el PC y la impresora estén en la misma red. Prueba a hacer ping a la IP.
- **`[ERROR] No se pudo imprimir en BARRA`**: revisa que
  `PRINTER_BARRA_PUERTO_WINDOWS` coincide exactamente con el puerto marcado
  en *Propiedades de la impresora → Puertos* (mayúsculas incluidas), y que
  la impresora está encendida y con papel. También prueba a ejecutar a mano
  `copy /b algún_archivo.txt USB001` (cambia el nombre del puerto) desde una
  consola `cmd` del propio PC de la TPV — si eso falla, es un problema del
  driver/puerto de Windows, no del servicio.
- **Imprime caracteres raros / no corta el papel**: prueba cambiando
  `type: PrinterTypes.EPSON` por `PrinterTypes.STAR` en `src/index.js` (hay
  dos instancias, `printerCocina` y `printerBarra` — cambia la que
  corresponda) — algunas impresoras genéricas responden mejor a uno u otro
  set de comandos.
- **No imprime nada al hacer un pedido**: comprueba en la consola que el
  canal Realtime dice `SUBSCRIBED`. Si no, revisa `BRIDGE_EMAIL` /
  `BRIDGE_PASSWORD` y que esa cuenta tenga acceso a `/admin` de La Osa.
