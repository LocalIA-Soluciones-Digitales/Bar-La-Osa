# TicketBAI / Batuz (Bizkaia)

Módulo para emitir facturas TicketBAI cuando se cobra una mesa en Palomita Bar (Barakaldo,
Bizkaia). Construido a partir de la lectura directa del PDF oficial "Especificaciones
funcionales y técnicas del sistema TicketBAI 1.2" (descargado de gipuzkoa.eus/batuz.eus el
2026-08-24), no de memoria ni de resúmenes de terceros.

## Estado: **no operativo todavía**, apagado por defecto

Con `TICKETBAI_ENABLED` distinto de `"true"` (el valor por defecto en `.env.example`), todo
el módulo es un no-op: `emitirFacturaTicketBai()` devuelve `{ habilitado: false }` de
inmediato y el ticket se imprime exactamente igual que antes de este cambio, sin identificativo
ni QR fiscal. **No poner `TICKETBAI_ENABLED=true` hasta que estén las dos cosas de abajo.**

## Lo que falta para que esto funcione de verdad

1. **Certificado digital de Palomita Bar SL** (certificado de representante o sello de
   entidad — ver conversación previa sobre qué certificado corresponde a quién). Sin él,
   `src/lib/ticketbai/firma.ts` lanza un error controlado a propósito: no tiene sentido
   escribir una firma XAdES-BES sin un certificado real contra el que probarla en el entorno
   de pruebas de Bizkaia. Cuando haya certificado, ese es el único archivo que hay que
   completar; el resto del pipeline (numeración, encadenamiento, XML, identificativo, QR) ya
   está listo para recibir el resultado de firmar.
2. **Envío a Batuz/LROE** (`src/lib/ticketbai/envio.ts`): no implementado. No se ha
   confirmado el endpoint/protocolo exacto — batuz.eus separa esto en documentos de "envío
   masivo LROE" aparte de las especificaciones funcionales de TicketBAI que sí se han leído.
   Sin esto, una factura queda en estado `FIRMADA` pero nunca `ENVIADA`. TicketBAI exige el
   envío, no basta con firmar.
3. **Registro del software** en el registro de software TBAI de cualquiera de las tres
   Haciendas Forales (da servicio a las tres): de ahí sale el número de
   `TICKETBAI_LICENCIA` que hay que rellenar en las variables de entorno.
4. Validar el XML generado (`src/lib/ticketbai/xml.ts`) contra el **XSD real** (descargable
   aparte en batuz.eus/es/documentacion-tecnica, no obtenido para esta implementación — el
   PDF leído da los campos como tabla en prosa, no como esquema literal) y contra el entorno
   de pruebas de Bizkaia antes de activar `TICKETBAI_ENABLED` en producción.

## Verificación adicional: ticket real del TPV actual (2026-08-29)

El usuario compartió una foto de un ticket real emitido por el TPV físico que Palomita Bar usa
hoy, y de la página de comprobación de Batuz tras escanear su QR. Sirve como confirmación
independiente (no solo contra el PDF oficial) de que este módulo replica el formato real:

- Identificativo real: `TBAI-22756634C-290826-F0bEm8Y8NQGqP-128` — mismo NIF que
  `SITE.nif`, misma estructura de 39 caracteres, mismo separador `-`, firma truncada a 13
  caracteres y CRC de 3 dígitos, exactamente como en `identificador.ts`.
- La página de Batuz (`batuz.eus/QRTBAI/...`) confirma por separado: `SERIE: FSE11`,
  `NÚMERO FACTURA: 35403`, `IMPORTE: 1,95`, `FECHA EMISIÓN: 29/08/2026` — mismos campos que
  genera `qr.ts`/`crear_factura_ticketbai`.
- **Dato operativo importante**: el TPV actual factura con la serie `FSE11`. Por eso
  `TICKETBAI_SERIE` tiene como valor por defecto `WEB` (antes era `A`) — tiene que ser distinta
  de la que ya usa el TPV en producción para que, cuando convivan los dos sistemas, nunca
  puedan chocar dos facturas con la misma serie+número del mismo NIF.
- Discrepancias vistas en el ticket, sin resolver todavía (no se han tocado los datos públicos
  del sitio sin confirmar): el ticket encabeza con **"Bar Palomita"** (orden invertido respecto
  al nombre comercial "Palomita Bar" de `SITE.name`), y trae un teléfono de contacto
  (`622598712`) distinto al que tiene la web (`+34 686 53 03 10`). Podría ser solo la
  plantilla del TPV, o podría ser la razón social/teléfono real — confirmar antes de rellenar
  `TICKETBAI_RAZON_SOCIAL` o de cambiar nada en `constants.ts`.

## Lo que sí está verificado contra el documento oficial

- **CRC-8** (`crc8.ts`): tabla copiada del Anexo 3, verificada byte a byte contra los dos
  ejemplos numéricos que trae el propio documento (`237` para el identificativo de ejemplo,
  `007` para el QR de ejemplo) — coincide exactamente.
- **Identificativo TBAI** (`identificador.ts`): formato de 39 caracteres
  `TBAI-{NIF}-{DDMMAA}-{13 primeros de SignatureValue}-{CRC8}`, verificado contra el ejemplo
  oficial `TBAI-00000006Y-251019-btFpwP8dcLGAF-237`.
- **QR TBAI** (`qr.ts`): URL base de Bizkaia `https://batuz.eus/QRTBAI/` (con barra final,
  como exige el documento para el cálculo del CRC), parámetros `id`/`s`/`nf`/`i`/`cr`,
  verificado contra el ejemplo oficial completo del documento.
- **Encadenamiento y numeración** (SQL, `crear_factura_ticketbai`): correlativo por
  cliente+serie con bloqueo (`pg_advisory_xact_lock`) para que dos mesas cerrándose a la vez
  no se lleven el mismo número; el campo de encadenamiento usa los primeros 100 caracteres
  del `SignatureValue` de la factura anterior, tal como especifica el documento.
- **IVA por línea** (`tipo-iva.ts`): 21% para bebidas alcohólicas, 10% para el resto
  (hostelería) — regla de la Ley del IVA española, no específica de TicketBAI, pero necesaria
  para que el desglose de IVA del fichero TBAI sea correcto. `restaurant.productos.alcohol_pct`
  ya existía en el proyecto (ficha nutricional), no ha hecho falta columna nueva.

## Lo que NO está verificado (usar con cautela, validar contra el XSD real)

- Nombre y namespace del elemento raíz del XML (`T:TicketBai`,
  `xmlns:T="urn:ticketbai:emision"`): es el que documentan de forma consistente varias
  implementaciones de referencia de terceros, no confirmado línea a línea contra el XSD
  oficial de Bizkaia.
- Nombres exactos de algunos campos intermedios y el orden exacto de los elementos (el XSD
  real es estricto con el orden; el PDF leído no lo es, solo da una tabla).
- Dónde engancha exactamente el `<ds:Signature>` de la firma XAdES — lo define la "Política
  de Firma TicketBAI", documento aparte no leído para esta implementación.

## Idempotencia: por qué "Imprimir cuenta" no genera una factura nueva cada vez

En el panel de salón (`SalonBoard.tsx`), "Imprimir cuenta" es una vista previa que se puede
pulsar varias veces antes de liberar la mesa — no hay hoy un paso explícito de "cerrar
cuenta" separado. TicketBAI prohíbe volver a emitir una factura ya generada (sección 6.1 de
las especificaciones), así que antes de crear una factura nueva se busca si ya existe una
para ese mismo conjunto de pedidos (`buscar_factura_ticketbai_por_pedidos`); si existe, se
reutiliza y el ticket se marca `*** DUPLICADO ***`.

## Archivos

- `types.ts` — tipos compartidos.
- `crc8.ts`, `identificador.ts`, `qr.ts` — verificados (ver arriba).
- `xml.ts` — generador del fichero TBAI sin firmar (ver limitaciones arriba).
- `tipo-iva.ts` — regla 10%/21% reutilizada tanto aquí como en el ticket impreso normal.
- `firma.ts` — interfaz de firma XAdES-BES, sin implementar (bloqueado por certificado).
- `envio.ts` — envío a Batuz/LROE, sin implementar (bloqueado por confirmar el endpoint).
- `index.ts` — orquestador (`emitirFacturaTicketBai`), punto de entrada único desde
  `app/api/ticketbai/emitir/route.ts`.
- `../../../supabase/ticketbai_2026-08-24.sql` — esquema (`restaurant.ticketbai_facturas`) y
  RPC. **No aplicado todavía** al proyecto Supabase compartido — a diferencia del resto de
  ficheros de esa carpeta, este se ha dejado para revisión antes de ejecutarlo.
