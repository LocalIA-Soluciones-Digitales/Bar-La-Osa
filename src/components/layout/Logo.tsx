/**
 * Marca tipográfica de La Osa: sin archivo de imagen (no hay logo real
 * entregado por el negocio todavía), un emblema de sol mediterráneo
 * dibujado en SVG y una wordmark en Playfair Display — el mismo registro
 * visual que firmas de hostelería de lujo (Nobu, Zuma) que no dependen de
 * un icono figurativo. Sustituir por el logo real es tan sencillo como
 * cambiar este componente, sin tocar Header/Footer/Hero/MobileNav.
 */
function SunMark({ className }: { className?: string }) {
  return (
    <svg viewBox="0 0 40 40" fill="none" className={className} aria-hidden="true">
      <circle cx="20" cy="20" r="8.5" stroke="currentColor" strokeWidth="1.4" />
      {Array.from({ length: 8 }).map((_, i) => {
        const angle = (i * Math.PI) / 4;
        const r1 = 13;
        const r2 = 18.5;
        const x1 = 20 + r1 * Math.cos(angle);
        const y1 = 20 + r1 * Math.sin(angle);
        const x2 = 20 + r2 * Math.cos(angle);
        const y2 = 20 + r2 * Math.sin(angle);
        return (
          <line
            key={i}
            x1={x1}
            y1={y1}
            x2={x2}
            y2={y2}
            stroke="currentColor"
            strokeWidth="1.4"
            strokeLinecap="round"
          />
        );
      })}
    </svg>
  );
}

export function Logo({
  size = "md",
  light = false,
  showTagline = true,
  stacked = false,
  className,
}: {
  size?: "sm" | "md" | "lg";
  light?: boolean;
  showTagline?: boolean;
  /** Emblema encima de la wordmark, centrado — para paneles móviles y portadas. */
  stacked?: boolean;
  className?: string;
}) {
  const mark = size === "lg" ? "h-10 w-10 sm:h-12 sm:w-12" : size === "sm" ? "h-7 w-7" : "h-8 w-8 sm:h-9 sm:w-9";
  const word = size === "lg" ? "text-3xl sm:text-4xl" : size === "sm" ? "text-lg" : "text-xl";

  return (
    <span
      className={`inline-flex leading-tight ${stacked ? "flex-col items-center gap-3 text-center" : "items-center gap-2.5"} ${className ?? ""}`}
    >
      <SunMark className={`${mark} shrink-0 ${light ? "text-white" : "text-noche-primary"}`} />
      <span>
        <span
          className={`block font-display ${word} tracking-wide ${light ? "text-white" : "text-noche-ink"}`}
        >
          La Osa
        </span>
        {showTagline ? (
          <span
            className={`mt-0.5 block text-[10px] uppercase tracking-widest2 ${light ? "text-white/70" : "text-noche-ink-muted"}`}
          >
            Bar de Tapas
          </span>
        ) : null}
      </span>
    </span>
  );
}
