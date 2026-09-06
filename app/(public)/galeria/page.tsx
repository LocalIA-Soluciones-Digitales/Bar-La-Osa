import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Galería",
  description: "Galería de Bar de Tapas La Osa, Port d'Alcúdia, Mallorca.",
};

// Sin reportaje fotográfico real todavía (ver static-content.ts): en vez de
// dejar la página vacía o reutilizar fotografía de otro negocio, cada
// tarjeta usa un tratamiento editorial de color con la paleta de marca.
// Sustituir `gradient` por una foto real es un cambio local a esta lista,
// sin tocar el layout de la galería.
const PIEZAS = [
  { titulo: "Terraza al atardecer", gradient: "linear-gradient(155deg, oklch(0.5 0.09 55), oklch(0.24 0.04 40))", span: "row-span-2" },
  { titulo: "Tapas de la casa", gradient: "linear-gradient(155deg, oklch(0.46 0.05 70), oklch(0.2 0.03 60))" },
  { titulo: "En la barra", gradient: "linear-gradient(155deg, oklch(0.38 0.04 250), oklch(0.18 0.02 240))" },
  { titulo: "Producto de mercado", gradient: "linear-gradient(155deg, oklch(0.52 0.1 130), oklch(0.24 0.04 120))" },
  { titulo: "Sala interior", gradient: "linear-gradient(155deg, oklch(0.42 0.03 60), oklch(0.16 0.02 55))", span: "row-span-2" },
  { titulo: "Vinos de Mallorca", gradient: "linear-gradient(155deg, oklch(0.4 0.1 20), oklch(0.18 0.05 15))" },
  { titulo: "Menú diario", gradient: "linear-gradient(155deg, oklch(0.5 0.07 85), oklch(0.22 0.035 75))" },
  { titulo: "Frituras y raciones", gradient: "linear-gradient(155deg, oklch(0.44 0.06 45), oklch(0.19 0.03 40))" },
  { titulo: "El mar de Port d'Alcúdia", gradient: "linear-gradient(155deg, oklch(0.44 0.07 220), oklch(0.16 0.03 230))" },
];

export default function GaleriaPage() {
  return (
    <div className="mx-auto max-w-6xl px-6 py-24">
      <p className="text-xs uppercase tracking-widest2 text-noche-primary">Galería</p>
      <h1 className="mt-4 font-display text-5xl italic text-noche-ink">En imágenes</h1>
      <p className="mt-4 max-w-lg text-noche-ink-muted">
        Estamos preparando el reportaje fotográfico real de La Osa: el local, la terraza y la
        carta. Mientras tanto, un adelanto de lo que encontrarás.
      </p>

      <div className="mt-16 grid auto-rows-[160px] grid-cols-2 gap-3 sm:auto-rows-[200px] sm:grid-cols-3">
        {PIEZAS.map((pieza) => (
          <div
            key={pieza.titulo}
            className={`group relative overflow-hidden rounded-lg ${pieza.span ?? ""}`}
            style={{ background: pieza.gradient }}
          >
            <div className="absolute inset-0 bg-gradient-to-t from-black/60 via-black/0 to-black/0 opacity-0 transition-opacity duration-300 group-hover:opacity-100" />
            <p className="absolute bottom-3 left-3 right-3 translate-y-2 font-display text-sm italic text-white opacity-0 transition-all duration-300 group-hover:translate-y-0 group-hover:opacity-100 sm:text-base">
              {pieza.titulo}
            </p>
          </div>
        ))}
      </div>
    </div>
  );
}
