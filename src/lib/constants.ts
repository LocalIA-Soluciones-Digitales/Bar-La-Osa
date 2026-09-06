export const SITE = {
  name: "Bar de Tapas La Osa",
  shortName: "La Osa",
  tagline: "Tapas mediterráneas en Port d'Alcúdia",
  // Aviso: no hay teléfono ni Instagram confirmados públicamente para este
  // negocio — se dejan en null a propósito (ver SITE.phone/instagram) en vez
  // de inventar un dato que un cliente real podría llamar o buscar.
  address: {
    line1: "Carretera d'Artà / Carrer de la Punta 30",
    postalCode: "07400",
    city: "Alcúdia",
    province: "Mallorca",
  },
  phone: null as string | null,
  phoneHref: null as string | null,
  instagram: null as { handle: string; url: string } | null,
  googleReviewsUrl:
    "https://www.google.com/search?q=Bar+de+Tapas+La+Osa+Alcúdia+reseñas",
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
