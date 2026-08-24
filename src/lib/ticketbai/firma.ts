import type { FacturaFirmada } from "@/lib/ticketbai/types";

/**
 * Firma XAdES-BES del fichero TBAI, tal como exige la "Política de Firma TicketBAI" (documento
 * aparte de las especificaciones funcionales, con cláusula de reciprocidad entre las tres
 * Haciendas Forales — para Bizkaia:
 * https://www.batuz.eus/fitxategiak/batuz/ticketbai/Especificaciones_firma_v1_0.pdf).
 *
 * DELIBERADAMENTE NO IMPLEMENTADO todavía: hacer una firma XAdES-BES correcta (canonicalización
 * exacta, SignedProperties, KeyInfo, política de firma referenciada) es fácil de hacer mal de
 * forma que "parezca" firmado pero sea rechazado por Hacienda o, peor, aceptado pero inválido.
 * No tiene sentido escribirlo sin un certificado real contra el que probarlo en el entorno de
 * pruebas de Bizkaia — Palomita Bar SL todavía no tiene ese certificado (ver conversación:
 * necesita el certificado de representante/sello de entidad de la SL).
 *
 * Cuando haya certificado, esta función es el único sitio que hay que rellenar. Librerías
 * candidatas en Node.js: `xadesjs` (implementación XAdES completa) + `node-forge` o
 * `@peculiar/webcrypto` para cargar el certificado .p12. El resto del módulo (numeración,
 * encadenamiento, XML, QR, identificativo) ya está listo para recibir el resultado de firmar.
 */
export interface FirmanteTicketBai {
  firmar(xmlSinFirmar: string): Promise<FacturaFirmada>;
}

export function getFirmanteTicketBai(): FirmanteTicketBai {
  return {
    async firmar(): Promise<FacturaFirmada> {
      throw new Error(
        "Firma TicketBAI no configurada: falta el certificado digital de Palomita Bar SL " +
          "(certificado de representante o sello de entidad) y su integración XAdES-BES en " +
          "src/lib/ticketbai/firma.ts. Ver el comentario de este archivo.",
      );
    },
  };
}
