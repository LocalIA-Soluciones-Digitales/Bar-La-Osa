import Image from "next/image";

/**
 * Marca de La Osa: la mascota real del negocio (recortada de su
 * tarjeta/flyer, ver public/images/logo-la-osa.png) en un marco circular
 * tipo insignia, junto a la wordmark en Playfair Display. El marco redondo
 * con anillo dorado disimula el fondo rojo original de la imagen (no hay
 * versión con fondo transparente) y da un acabado de sello/crest coherente
 * con el resto de la identidad.
 */
function MascotMark({ className }: { className?: string }) {
  return (
    <span
      className={`relative block shrink-0 overflow-hidden rounded-full ring-2 ring-noche-primary/70 ${className ?? ""}`}
    >
      <Image
        src="/images/logo-la-osa.png"
        alt=""
        fill
        sizes="64px"
        className="scale-[1.35] object-cover object-[50%_20%]"
      />
    </span>
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
  const mark = size === "lg" ? "h-12 w-12 sm:h-14 sm:w-14" : size === "sm" ? "h-8 w-8" : "h-9 w-9 sm:h-10 sm:w-10";
  const word = size === "lg" ? "text-3xl sm:text-4xl" : size === "sm" ? "text-lg" : "text-xl";

  return (
    <span
      className={`inline-flex leading-tight ${stacked ? "flex-col items-center gap-3 text-center" : "items-center gap-2.5"} ${className ?? ""}`}
    >
      <MascotMark className={mark} />
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
