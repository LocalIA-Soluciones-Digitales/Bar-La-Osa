"use client";

import Image from "next/image";
import { useScrollReveal } from "@/hooks/useScrollReveal";

/** Panel editorial cuando no hay foto real todavía: piedra caliza y luz
 * cálida en vez de un hueco vacío, coherente con el resto de la web. */
function StonePanel() {
  return (
    <div
      className="h-full w-full"
      style={{
        background:
          "linear-gradient(155deg, oklch(0.42 0.03 70) 0%, oklch(0.28 0.025 65) 55%, oklch(0.18 0.02 60) 100%)",
      }}
    >
      <div
        className="h-full w-full opacity-40"
        style={{
          backgroundImage:
            "repeating-linear-gradient(115deg, transparent 0px, transparent 38px, oklch(1 0 0 / 0.05) 38px, oklch(1 0 0 / 0.05) 40px)",
        }}
      />
    </div>
  );
}

export function AboutSection({ image }: { image: string | null }) {
  const { ref, visible } = useScrollReveal<HTMLDivElement>();

  return (
    <section id="esencia" className="bg-noche-bg px-6 py-16 md:py-24">
      <div
        ref={ref}
        className={`mx-auto grid max-w-7xl items-center gap-16 transition-all duration-700 md:grid-cols-2 ${
          visible ? "translate-y-0 opacity-100" : "translate-y-8 opacity-0"
        }`}
      >
        <div className="relative order-2 aspect-[4/5] w-full lg:order-1">
          <div className="absolute -bottom-6 -right-6 -z-10 h-32 w-32 rounded-lg border border-noche-primary/30 md:h-40 md:w-40" />
          <div className="relative h-full w-full overflow-hidden rounded-lg">
            {image ? (
              <Image
                src={image}
                alt="Interior de Bar de Tapas La Osa"
                fill
                sizes="(min-width: 768px) 480px, 100vw"
                className="object-cover"
              />
            ) : (
              <StonePanel />
            )}
          </div>
        </div>

        <div className="order-1 lg:order-2">
          <p className="flex items-center gap-3 text-xs uppercase tracking-widest2 text-noche-primary">
            <span className="h-px w-6 bg-noche-primary/50" />
            Nuestra esencia
          </p>
          <h2 className="mt-4 font-display text-4xl font-light italic leading-tight text-noche-ink md:text-5xl lg:text-6xl">
            Mallorca, servida en un plato
          </h2>
          <p className="mt-6 max-w-md text-noche-ink/70">
            En La Osa creemos en la mesa como punto de encuentro: producto fresco de mercado,
            recetas mediterráneas con oficio y la calma de comer sin prisa, mirando al mar de
            Port d&apos;Alcúdia.
          </p>
          <p className="mt-4 max-w-md text-noche-ink/70">
            Tapas para compartir, un menú diario honesto y una terraza donde el atardecer es
            parte del servicio. Así entendemos la gastronomía española: cercana, auténtica y sin
            solemnidad.
          </p>

          <ul className="mt-6 flex flex-wrap gap-x-6 gap-y-2 text-sm text-noche-ink-muted">
            <li className="flex items-center gap-2">
              <span className="h-1 w-1 rounded-full bg-noche-primary" />
              Producto de mercado
            </li>
            <li className="flex items-center gap-2">
              <span className="h-1 w-1 rounded-full bg-noche-primary" />
              Tapas para compartir
            </li>
            <li className="flex items-center gap-2">
              <span className="h-1 w-1 rounded-full bg-noche-primary" />
              Tradición mediterránea
            </li>
          </ul>
        </div>
      </div>
    </section>
  );
}
