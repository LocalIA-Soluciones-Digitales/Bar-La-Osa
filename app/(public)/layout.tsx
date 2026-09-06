import { Header } from "@/components/layout/Header";
import { Footer } from "@/components/layout/Footer";
import { ActiveOrderBanner } from "@/components/pedido/ActiveOrderBanner";
import { SITE } from "@/lib/constants";
import { DIAS_SEMANA, semanaPorDefecto } from "@/lib/horario";

const DIA_SCHEMA_ORG: Record<(typeof DIAS_SEMANA)[number], string> = {
  Lunes: "Monday",
  Martes: "Tuesday",
  Miércoles: "Wednesday",
  Jueves: "Thursday",
  Viernes: "Friday",
  Sábado: "Saturday",
  Domingo: "Sunday",
};

// Script inline mínimo (sin dependencia de props ni datos de usuario) que
// aplica el tema guardado antes del primer paint, para que el toggle de
// ThemeToggle no provoque un parpadeo del tema oscuro al cargar la página.
const THEME_INIT_SCRIPT = `try{if(localStorage.getItem("laosa.tema")==="dia"){document.documentElement.setAttribute("data-theme","dia")}}catch(e){}`;

const SITE_URL = process.env.NEXT_PUBLIC_SITE_URL ?? "https://barlaosa.es";

export default function PublicLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  // Horario de referencia (ver src/lib/horario.ts): mientras no haya un
  // tenant conectado, se usa el mismo horario aproximado en todas partes
  // (JSON-LD, LocationSection, ReservaForm) en vez de una RPC en vivo.
  const semana = semanaPorDefecto();

  const openingHoursSpecification = semana
    .map((dia, index) => ({ dia, nombre: DIAS_SEMANA[index]! }))
    .filter(({ dia }) => dia.abierto)
    .map(({ dia, nombre }) => ({
      "@type": "OpeningHoursSpecification",
      dayOfWeek: DIA_SCHEMA_ORG[nombre],
      opens: dia.desde,
      closes: dia.hasta,
    }));

  const structuredData = {
    "@context": "https://schema.org",
    "@type": "Restaurant",
    name: SITE.name,
    servesCuisine: ["Spanish", "Mediterranean", "Tapas"],
    priceRange: "€€",
    address: {
      "@type": "PostalAddress",
      streetAddress: SITE.address.line1,
      postalCode: SITE.address.postalCode,
      addressLocality: SITE.address.city,
      addressRegion: SITE.address.province,
      addressCountry: "ES",
    },
    ...(SITE.phone ? { telephone: SITE.phone } : {}),
    ...(SITE.instagram ? { sameAs: [SITE.instagram.url] } : {}),
    url: SITE_URL,
    openingHoursSpecification,
  };

  return (
    <div className="flex min-h-screen flex-col bg-noche-bg text-noche-ink">
      <script dangerouslySetInnerHTML={{ __html: THEME_INIT_SCRIPT }} />
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(structuredData) }}
      />
      <Header />
      <main className="flex-1">{children}</main>
      <Footer />
      <ActiveOrderBanner />
    </div>
  );
}
