export const SITE = {
  name: "Bar de Tapas La Osa",
  shortName: "La Osa",
  tagline: "Tapas mediterráneas en Port d'Alcúdia",
  // Dirección y teléfonos: confirmados por el propio negocio (tarjeta/flyer
  // real, 2026-09-06) — ya no son un dato sin verificar.
  address: {
    line1: "Ctra. Artà, 30",
    postalCode: "07400",
    city: "Port d'Alcúdia",
    province: "Mallorca",
  },
  // Línea principal (fija) y una segunda de contacto (móvil).
  phone: "971 781 810",
  phoneHref: "tel:+34971781810",
  phoneSecondary: "681 248 898",
  phoneSecondaryHref: "tel:+34681248898",
  // Instagram no confirmado todavía — se deja en null a propósito en vez de
  // inventar o adivinar un @handle.
  instagram: null as { handle: string; url: string } | null,
  googleReviewsUrl:
    "https://www.google.com/search?q=Bar+de+Tapas+La+Osa+Port+d'Alcúdia+reseñas",
  // "Aproximado", como se indica en la información pública disponible.
  // Editable desde /admin/configuracion en cuanto haya un tenant conectado;
  // este valor es el contenido de referencia mientras tanto.
  hoursNote: "Viernes a miércoles: 7:30–23:00\nJueves: cerrado",
} as const;

export const NAV_LINKS = [
  { href: "/#esencia", label: "Nuestra Esencia" },
  { href: "/carta", label: "Carta" },
  { href: "/bebidas", label: "Bebidas" },
  { href: "/galeria", label: "Galería" },
  { href: "/reservar", label: "Reservar" },
  { href: "/opiniones", label: "Opiniones" },
  { href: "/#contacto", label: "Contacto" },
] as const;
