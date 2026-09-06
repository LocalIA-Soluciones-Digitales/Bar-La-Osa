"use client";

import Image from "next/image";
import Link from "next/link";
import { useScrollReveal } from "@/hooks/useScrollReveal";

/** Tratamiento cinematográfico de la terraza sin foto real todavía: luz de
 * mediodía sobre piedra clara, coherente con el resto del sitio. */
function TerraceCanvas() {
  return (
    <div
      className="absolute inset-0"
      style={{
        background:
          "linear-gradient(160deg, oklch(0.5 0.05 90) 0%, oklch(0.36 0.045 80) 45%, oklch(0.2 0.03 70) 100%)",
      }}
    />
  );
}

export function TerraceSection({ image }: { image: string | null }) {
  const { ref, visible } = useScrollReveal<HTMLDivElement>();

  return (
    <section className="relative overflow-hidden border-t border-noche-border py-28">
      {image ? (
        <Image src={image} alt="Terraza de La Osa" fill sizes="100vw" className="object-cover" />
      ) : (
        <TerraceCanvas />
      )}
      <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-black/35 to-black/10" />

      <div
        ref={ref}
        className={`relative mx-auto max-w-3xl px-6 text-center transition-all duration-700 ${
          visible ? "translate-y-0 opacity-100" : "translate-y-8 opacity-0"
        }`}
      >
        <p className="flex items-center justify-center gap-3 text-xs uppercase tracking-widest2 text-noche-primary">
          <span className="h-px w-6 bg-noche-primary/60" />
          Terraza La Osa
          <span className="h-px w-6 bg-noche-primary/60" />
        </p>
        <h2 className="mt-4 font-display text-4xl italic leading-tight text-white md:text-5xl">
          Disfrutar Mallorca al aire libre
        </h2>
        <p className="mx-auto mt-6 max-w-xl text-white/80">
          Mesas a pie de calle en Port d&apos;Alcúdia, luz mediterránea y el ritmo lento de una
          buena sobremesa. La terraza es donde La Osa se disfruta mejor: de desayuno con el
          periódico a copa de vino al atardecer.
        </p>
        <Link
          href="/reservar"
          className="mt-8 inline-flex items-center rounded-full bg-noche-primary px-7 py-3.5 text-sm font-medium uppercase tracking-widest2 text-noche-bg transition-colors hover:bg-noche-primary-dark"
        >
          Reservar en terraza
        </Link>
      </div>
    </section>
  );
}
