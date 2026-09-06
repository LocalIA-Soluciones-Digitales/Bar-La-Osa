import type { MetadataRoute } from "next";

// "/#esencia" y "/#contacto" no son rutas propias: son secciones de la
// portada (ver NAV_LINKS en src/lib/constants.ts), ya cubiertas por "".
const routes = ["", "/carta", "/bebidas", "/galeria", "/reservar", "/opiniones"];

export default function sitemap(): MetadataRoute.Sitemap {
  const base = process.env.NEXT_PUBLIC_SITE_URL || "https://barlaosa.es";

  return routes.map((route) => ({
    url: `${base}${route}`,
    lastModified: new Date(),
  }));
}
