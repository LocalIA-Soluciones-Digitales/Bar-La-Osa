import type { ZonaAdmin } from "@/lib/restaurant/admin-types";

export type TarifaZona = "barra" | "salon" | "terraza";

/** Determina la tarifa aplicable a partir del nombre de la zona (mismo criterio
 * de substring que prefijoZona en mesa-label.ts). Por defecto "salon". */
export function tarifaDeZona(zonaId: string | null | undefined, zonas: ZonaAdmin[]): TarifaZona {
  if (!zonaId) return "salon";
  const nombre = zonas.find((z) => z.id === zonaId)?.nombre.toLowerCase() ?? "";
  if (nombre.includes("terraza")) return "terraza";
  if (nombre.includes("bar")) return "barra";
  return "salon";
}

interface ProductoConTarifas {
  precio_centimos: number;
  precio_barra_centimos?: number | null;
  precio_salon_centimos?: number | null;
  precio_terraza_centimos?: number | null;
}

/** Precio en céntimos para la tarifa dada, con fallback al precio único
 * (precio_centimos) cuando el producto no tiene tarifas específicas fijadas. */
export function precioPorTarifa(producto: ProductoConTarifas, tarifa: TarifaZona): number {
  const especifico =
    tarifa === "barra"
      ? producto.precio_barra_centimos
      : tarifa === "terraza"
        ? producto.precio_terraza_centimos
        : producto.precio_salon_centimos;
  return especifico ?? producto.precio_centimos;
}
