"use client";

import Link from "next/link";
import { useScrollReveal } from "@/hooks/useScrollReveal";
import { CheckIcon } from "@/components/icons";

const OCASIONES = [
  "Cumpleaños y aniversarios",
  "Grupos y comidas de empresa",
  "Comidas familiares",
  "Reuniones y celebraciones especiales",
];

export function CelebrationsSection() {
  const { ref, visible } = useScrollReveal<HTMLDivElement>();

  return (
    <section className="border-t border-noche-border bg-noche-surface px-6 py-28">
      <div
        ref={ref}
        className={`mx-auto grid max-w-6xl items-center gap-14 transition-all duration-700 lg:grid-cols-2 ${
          visible ? "translate-y-0 opacity-100" : "translate-y-8 opacity-0"
        }`}
      >
        <div>
          <p className="flex items-center gap-3 text-xs uppercase tracking-widest2 text-noche-primary">
            <span className="h-px w-6 bg-noche-primary/50" />
            Celebraciones
          </p>
          <h2 className="mt-4 font-display text-4xl italic leading-tight text-noche-ink md:text-5xl">
            Momentos para celebrar en buena compañía
          </h2>
          <p className="mt-6 max-w-lg text-noche-ink/70">
            Organizamos tu celebración a medida: desde una comida familiar tranquila hasta un
            grupo grande en terraza. Cuéntanos la ocasión y preparamos la mesa, el menú y los
            detalles.
          </p>

          <Link
            href="/reservar"
            className="mt-8 inline-flex items-center rounded-full bg-noche-primary px-7 py-3.5 text-sm font-medium uppercase tracking-widest2 text-noche-bg transition-colors hover:bg-noche-primary-dark"
          >
            Consultar disponibilidad
          </Link>
        </div>

        <ul className="grid gap-4 sm:grid-cols-2">
          {OCASIONES.map((ocasion) => (
            <li
              key={ocasion}
              className="flex items-start gap-3 rounded-lg border border-noche-border bg-noche-bg p-5"
            >
              <span className="mt-0.5 flex h-6 w-6 shrink-0 items-center justify-center rounded-full bg-noche-primary/15 text-noche-primary">
                <CheckIcon className="h-3.5 w-3.5" />
              </span>
              <span className="text-sm text-noche-ink/85">{ocasion}</span>
            </li>
          ))}
        </ul>
      </div>
    </section>
  );
}
