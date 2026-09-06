import type { Metadata } from "next";
import { CATEGORIAS, PRODUCTOS } from "@/lib/restaurant/static-content";
import { CategoryMenu } from "@/components/menu/CategoryMenu";
import { buildMenuJsonLd } from "@/lib/restaurant/menu-jsonld";

export const metadata: Metadata = {
  title: "Carta",
  description:
    "Carta de Bar de Tapas La Osa en Port d'Alcúdia: tapas para compartir, raciones, frituras, hamburguesas gourmet, bocadillos, desayunos, brunch y menú diario.",
};

export default async function CartaPage({
  searchParams,
}: {
  searchParams: Promise<{ product?: string }>;
}) {
  const { product } = await searchParams;
  const comida = CATEGORIAS.filter((categoria) => categoria.tipo === "comida");
  const menuJsonLd = buildMenuJsonLd(comida, PRODUCTOS, "Carta — Bar de Tapas La Osa");

  return (
    <div className="mx-auto max-w-4xl px-6 py-24">
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(menuJsonLd) }}
      />
      <p className="text-xs uppercase tracking-widest2 text-noche-primary">Carta</p>
      <h1 className="mt-4 font-display text-5xl italic text-noche-ink">Nuestra carta</h1>
      <p className="mt-4 max-w-lg text-noche-ink-muted">
        Tapas para compartir, raciones y platos de la casa con producto de mercado. ¿Buscas
        bebidas, cervezas o vino? Están en{" "}
        <a href="/bebidas" className="underline underline-offset-2 hover:text-noche-primary">
          Bebidas
        </a>
        .
      </p>

      <div className="mt-8">
        <CategoryMenu categorias={comida} productos={PRODUCTOS} highlightProductId={product} />
      </div>
    </div>
  );
}
