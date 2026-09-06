import type { Metadata } from "next";
import { getCarta, getCategorias } from "@/lib/restaurant/queries";
import { CategoryMenu } from "@/components/menu/CategoryMenu";
import { buildMenuJsonLd } from "@/lib/restaurant/menu-jsonld";

export const revalidate = 60;

export const metadata: Metadata = {
  title: "Bebidas",
  description:
    "Bebidas, cervezas y vinos de Bar de Tapas La Osa en Port d'Alcúdia: vinos mallorquines, cerveza artesana local y refrescos.",
};

export default async function BebidasPage({
  searchParams,
}: {
  searchParams: Promise<{ product?: string }>;
}) {
  const [{ product }, categorias, productos] = await Promise.all([
    searchParams,
    getCategorias(),
    getCarta(),
  ]);
  const bebidas = categorias.filter((categoria) => categoria.tipo === "bebida");
  const menuJsonLd = buildMenuJsonLd(bebidas, productos, "Bebidas — Bar de Tapas La Osa");

  return (
    <div className="mx-auto max-w-4xl px-6 py-24">
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(menuJsonLd) }}
      />
      <p className="text-xs uppercase tracking-widest2 text-noche-primary">Bebidas</p>
      <h1 className="mt-4 font-display text-5xl italic text-noche-ink">De la barra</h1>
      <p className="mt-4 max-w-lg text-noche-ink-muted">
        Vinos de bodegas mallorquinas, cerveza artesana local y refrescos. ¿Buscas la carta de
        comida? Está en{" "}
        <a href="/carta" className="underline underline-offset-2 hover:text-noche-primary">
          Carta
        </a>
        .
      </p>

      <div className="mt-8">
        <CategoryMenu categorias={bebidas} productos={productos} highlightProductId={product} />
      </div>
    </div>
  );
}
