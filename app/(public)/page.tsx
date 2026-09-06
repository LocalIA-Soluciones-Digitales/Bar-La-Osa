import { CATEGORIAS, PRODUCTOS, RESENAS, SITE_IMAGES } from "@/lib/restaurant/static-content";
import { HeroSection } from "@/components/home/HeroSection";
import { AboutSection } from "@/components/home/AboutSection";
import { CuratedSection } from "@/components/home/CuratedSection";
import { TerraceSection } from "@/components/home/TerraceSection";
import { CelebrationsSection } from "@/components/home/CelebrationsSection";
import { ReviewsSection } from "@/components/home/ReviewsSection";
import { AmbienceSection } from "@/components/home/AmbienceSection";
import { LocationSection } from "@/components/home/LocationSection";

// Contenido de la carta, imágenes de sitio y reseñas vienen de
// static-content.ts mientras no haya un tenant Supabase real conectado
// para La Osa (ver ARCHITECTURE.md y src/lib/restaurant/queries.ts, que
// quedan intactos para reconectar esto con un cambio de import).

export default function HomePage() {
  const destacados = PRODUCTOS.filter((p) => p.destacado && p.disponible).slice(0, 6);

  return (
    <>
      <HeroSection image={SITE_IMAGES} />
      <AboutSection image={SITE_IMAGES} />
      <CuratedSection productos={destacados} categorias={CATEGORIAS} />
      <TerraceSection image={SITE_IMAGES} />
      <CelebrationsSection />
      <ReviewsSection resenas={RESENAS} />
      <AmbienceSection images={SITE_IMAGES ?? []} />
      <LocationSection horario={null} />
    </>
  );
}
