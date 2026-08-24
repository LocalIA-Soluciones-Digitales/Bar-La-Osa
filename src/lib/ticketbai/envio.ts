/**
 * Envío del fichero TBAI firmado a la Hacienda Foral de Bizkaia (Batuz/LROE).
 *
 * NO IMPLEMENTADO: no se ha confirmado contra documentación oficial cuál es el endpoint/
 * protocolo exacto de envío (Bizkaia lo gestiona dentro de Batuz/LROE, con especificaciones
 * de "envío masivo" y de "anotaciones" que son documentos aparte de las especificaciones
 * funcionales de TicketBAI que sí se han leído para el resto de este módulo — ver
 * https://www.batuz.eus/es/documentacion-tecnica). Lo único confirmado y ya implementado es
 * la URL de verificación del QR (src/lib/ticketbai/qr.ts, https://batuz.eus/QRTBAI/), que es
 * para el destinatario de la factura, no el canal de envío del software a Hacienda.
 *
 * Mientras esto no esté implementado, una factura queda en estado 'FIRMADA' (una vez haya
 * certificado y firma real) pero nunca pasa a 'ENVIADA'. Es una limitación conocida: TicketBAI
 * exige el envío, no basta con firmar. Hay que completar esto antes de operar en producción.
 */
export async function enviarFacturaTicketBai(): Promise<never> {
  throw new Error(
    "Envío a Batuz/LROE no implementado: falta confirmar el endpoint y protocolo exactos " +
      "contra la documentación técnica de batuz.eus. Ver el comentario de este archivo.",
  );
}
