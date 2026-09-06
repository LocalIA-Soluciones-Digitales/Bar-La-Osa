"use client";

import { useEffect, useState } from "react";
import Image from "next/image";
import Link from "next/link";
import { SITE } from "@/lib/constants";

/**
 * Lienzo de portada cinematográfico cuando no hay foto real todavía
 * (`image` es null): capas de degradado que evocan un atardecer
 * mediterráneo sobre el mar en Port d'Alcúdia — sol bajo, piedra caliza,
 * horizonte marino — en vez de dejar el hero vacío o usar fotografía de
 * otro negocio. El día que exista el reportaje real, basta con pasar
 * `image` y esta capa deja de renderizarse.
 */
function SunsetCanvas() {
  return (
    <div className="absolute inset-0" aria-hidden="true">
      <div
        className="absolute inset-0"
        style={{
          background:
            "linear-gradient(180deg, oklch(0.22 0.03 280) 0%, oklch(0.34 0.07 30) 38%, oklch(0.62 0.13 55) 62%, oklch(0.4 0.09 210) 78%, oklch(0.14 0.03 240) 100%)",
        }}
      />
      <div
        className="absolute left-1/2 top-[42%] h-[38vh] w-[38vh] -translate-x-1/2 -translate-y-1/2 rounded-full"
        style={{
          background:
            "radial-gradient(circle, oklch(0.85 0.11 75) 0%, oklch(0.75 0.14 55 / 0.7) 45%, transparent 72%)",
          filter: "blur(2px)",
        }}
      />
      <div
        className="absolute inset-x-0 top-[58%] bottom-0"
        style={{
          background:
            "repeating-linear-gradient(180deg, oklch(0.3 0.06 220 / 0.5) 0px, oklch(0.3 0.06 220 / 0.5) 2px, transparent 2px, transparent 22px)",
        }}
      />
    </div>
  );
}

export function HeroSection({ image }: { image: string | null }) {
  const [loaded, setLoaded] = useState(false);

  useEffect(() => {
    const timeout = setTimeout(() => setLoaded(true), 100);
    return () => clearTimeout(timeout);
  }, []);

  return (
    <section className="relative flex min-h-[92vh] flex-col items-center justify-center overflow-hidden bg-noche-bg px-6 pb-20 pt-32">
      {image ? (
        <Image src={image} alt="" fill priority sizes="100vw" className="object-cover" />
      ) : (
        <SunsetCanvas />
      )}
      {/* Velo del hero: siempre oscuro (ver --hero-scrim-* en globals.css,
          fijo en ambos temas). El texto de aquí abajo es blanco fijo, no
          noche-ink, porque el fondo es oscuro en los dos modos. */}
      <div
        className="absolute inset-0"
        style={{
          backgroundImage:
            "linear-gradient(to top, var(--hero-scrim-a), var(--hero-scrim-b), var(--hero-scrim-c))",
        }}
      />
      <div
        className="absolute inset-0"
        style={{
          backgroundImage:
            "linear-gradient(to right, var(--hero-vignette), transparent, var(--hero-vignette))",
        }}
      />

      <div className="relative mx-auto flex w-full max-w-2xl flex-col items-center text-center">
        <p
          className={`flex items-center gap-3 text-xs uppercase tracking-widest2 text-noche-primary transition-all duration-1000 ${
            loaded ? "translate-y-0 opacity-100" : "translate-y-6 opacity-0"
          }`}
        >
          <span className="h-px w-8 bg-noche-primary/60" />
          Port d&apos;Alcúdia · Mallorca
          <span className="h-px w-8 bg-noche-primary/60" />
        </p>
        <h1
          className={`mt-6 font-display text-5xl italic leading-[1.05] text-white transition-all duration-1000 sm:text-7xl ${
            loaded ? "translate-y-0 opacity-100" : "translate-y-6 opacity-0"
          }`}
          style={{ transitionDelay: "120ms" }}
        >
          El sabor auténtico de Mallorca
        </h1>
        <p
          className={`mt-6 max-w-md text-lg text-white/80 transition-all duration-1000 ${
            loaded ? "translate-y-0 opacity-100" : "translate-y-6 opacity-0"
          }`}
          style={{ transitionDelay: "300ms" }}
        >
          Tapas, tradición y momentos inolvidables en el corazón de Port d&apos;Alcúdia.
        </p>

        <div
          className={`mt-10 flex flex-wrap justify-center gap-4 transition-all duration-1000 ${
            loaded ? "translate-y-0 opacity-100" : "translate-y-6 opacity-0"
          }`}
          style={{ transitionDelay: "450ms" }}
        >
          <Link
            href="/reservar"
            className="inline-flex items-center rounded-full bg-noche-primary px-7 py-3.5 text-sm font-medium uppercase tracking-widest2 text-noche-bg transition-colors hover:bg-noche-primary-dark"
          >
            Reservar mesa
          </Link>
          <Link
            href="/carta"
            className="inline-flex items-center rounded-full border border-white/30 px-7 py-3.5 text-sm font-medium uppercase tracking-widest2 text-white transition-colors hover:border-noche-primary hover:text-noche-primary"
          >
            Descubrir la carta
          </Link>
        </div>

        <p
          className={`mt-10 text-xs uppercase tracking-widest2 text-white/60 transition-all duration-1000 ${
            loaded ? "translate-y-0 opacity-100" : "translate-y-6 opacity-0"
          }`}
          style={{ transitionDelay: "600ms" }}
        >
          {SITE.hoursNote.split("\n")[0]}
        </p>
      </div>

      <a
        href="#esencia"
        aria-label="Descubre más"
        className={`absolute bottom-8 left-1/2 -translate-x-1/2 text-white/60 transition-opacity duration-700 ${
          loaded ? "opacity-100" : "opacity-0"
        }`}
      >
        <span className="block animate-bounce text-2xl">↓</span>
      </a>
    </section>
  );
}
