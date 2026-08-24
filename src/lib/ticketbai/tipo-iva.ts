/**
 * Tipo de IVA aplicable a una línea de venta en hostelería en España: el 10% reducido cubre
 * comida y bebidas SIN alcohol; las bebidas alcohólicas (incluida toda la coctelería) van
 * siempre al 21% general, se consuman o no en el propio local (Ley 37/1992 del IVA, art. 91,
 * exclusión de bebidas alcohólicas del tipo reducido).
 *
 * `restaurant.productos.alcohol_pct` ya existe (viene de la ficha nutricional/macros), así
 * que no hace falta ningún campo nuevo: cualquier producto con alcohol_pct > 0 se factura al
 * 21%, el resto al 10%.
 */
export function tipoIvaProducto(alcoholPct: number | null | undefined): 10 | 21 {
  return (alcoholPct ?? 0) > 0 ? 21 : 10;
}
