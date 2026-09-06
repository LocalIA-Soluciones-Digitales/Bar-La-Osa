import type { Categoria, Producto, ResenaPublica } from "@/lib/restaurant/types";

/**
 * Contenido de referencia de la carta pública mientras no hay un tenant
 * Supabase real conectado para Bar de Tapas La Osa (ver ARCHITECTURE.md).
 * Mismo shape exacto que devuelven las RPC `get_categorias_publica` /
 * `get_carta_publica` (src/lib/restaurant/queries.ts), así que sustituir
 * esto por esas llamadas el día que exista el tenant es un cambio de una
 * línea en cada página que lo usa, no un rediseño.
 *
 * Precios y platos son contenido de marketing genérico premium acorde al
 * tipo de oferta descrita para el negocio (tapas, raciones, frituras,
 * hamburguesas, bocadillos, desayunos/brunch, menú diario, bebidas,
 * cervezas, vinos) — no se han inventado datos empresariales críticos
 * (dirección, horario aproximado y ubicación sí son los verificados en
 * SITE, ver src/lib/constants.ts).
 */

function producto(p: {
  id: string;
  categoria_id: string;
  nombre: string;
  descripcion: string;
  precio: number;
  destacado?: boolean;
  alergenos?: string[];
  orden: number;
}): Producto {
  return {
    id: p.id,
    categoria_id: p.categoria_id,
    nombre: p.nombre,
    descripcion: p.descripcion,
    precio_centimos: p.precio,
    precio_barra_centimos: null,
    precio_salon_centimos: null,
    precio_terraza_centimos: null,
    imagen_url: null,
    disponible: true,
    destacado: p.destacado ?? false,
    alergenos: p.alergenos ?? [],
    orden: p.orden,
    ingredientes: [],
    calorias: null,
    proteinas_g: null,
    carbohidratos_g: null,
    grasas_g: null,
    grasas_saturadas_g: null,
    azucares_g: null,
    sal_g: null,
    alcohol_pct: null,
  };
}

export const CATEGORIAS: Categoria[] = [
  { id: "cat-desayunos", nombre: "Desayunos", slug: "desayunos", tipo: "comida", orden: 1 },
  { id: "cat-brunch", nombre: "Brunch", slug: "brunch", tipo: "comida", orden: 2 },
  { id: "cat-tapas", nombre: "Tapas para Compartir", slug: "tapas", tipo: "comida", orden: 3 },
  { id: "cat-raciones", nombre: "Raciones", slug: "raciones", tipo: "comida", orden: 4 },
  { id: "cat-frituras", nombre: "Frituras", slug: "frituras", tipo: "comida", orden: 5 },
  {
    id: "cat-hamburguesas",
    nombre: "Hamburguesas Gourmet",
    slug: "hamburguesas",
    tipo: "comida",
    orden: 6,
  },
  { id: "cat-bocadillos", nombre: "Bocadillos", slug: "bocadillos", tipo: "comida", orden: 7 },
  { id: "cat-menu-diario", nombre: "Menú Diario", slug: "menu-diario", tipo: "comida", orden: 8 },
  { id: "cat-bebidas", nombre: "Bebidas", slug: "bebidas", tipo: "bebida", orden: 1 },
  { id: "cat-cervezas", nombre: "Cervezas", slug: "cervezas", tipo: "bebida", orden: 2 },
  { id: "cat-vinos", nombre: "Vinos", slug: "vinos", tipo: "bebida", orden: 3 },
];

export const PRODUCTOS: Producto[] = [
  // Desayunos
  producto({
    id: "p-tostada-tomate",
    categoria_id: "cat-desayunos",
    nombre: "Tostada de pan payés con tomate y aceite de oliva virgen",
    descripcion: "Pan de payés tostado, tomate de temporada rallado y AOVE mallorquín.",
    precio: 450,
    orden: 1,
  }),
  producto({
    id: "p-tostada-jamon",
    categoria_id: "cat-desayunos",
    nombre: "Tostada con jamón ibérico y tomate",
    descripcion: "Pan payés, tomate rallado, aceite de oliva virgen extra y jamón ibérico.",
    precio: 750,
    orden: 2,
    alergenos: ["gluten"],
  }),
  producto({
    id: "p-huevos-rotos",
    categoria_id: "cat-desayunos",
    nombre: "Huevos rotos con patatas y jamón",
    descripcion: "Huevos camperos rotos sobre patatas fritas al momento y jamón curado.",
    precio: 850,
    orden: 3,
    alergenos: ["huevo"],
  }),
  producto({
    id: "p-cafe-bollo",
    categoria_id: "cat-desayunos",
    nombre: "Café y ensaimada mallorquina",
    descripcion: "Ensaimada artesana recién horneada con el café de la casa.",
    precio: 480,
    orden: 4,
    alergenos: ["gluten", "huevo"],
  }),

  // Brunch
  producto({
    id: "p-brunch-osa",
    categoria_id: "cat-brunch",
    nombre: "Brunch La Osa",
    descripcion:
      "Huevos al gusto, aguacate, jamón ibérico, tostada de payés y zumo de naranja recién exprimido.",
    precio: 1450,
    destacado: true,
    orden: 1,
    alergenos: ["gluten", "huevo"],
  }),
  producto({
    id: "p-tostada-aguacate",
    categoria_id: "cat-brunch",
    nombre: "Tostada de aguacate y huevo pochado",
    descripcion: "Aguacate, huevo pochado, semillas tostadas y un toque de guindilla.",
    precio: 950,
    orden: 2,
    alergenos: ["gluten", "huevo"],
  }),
  producto({
    id: "p-bowl-yogur",
    categoria_id: "cat-brunch",
    nombre: "Bowl de yogur griego, fruta y granola casera",
    descripcion: "Yogur griego, fruta de temporada, granola tostada en casa y miel.",
    precio: 750,
    orden: 3,
    alergenos: ["lácteos", "frutos de cáscara"],
  }),

  // Tapas para compartir
  producto({
    id: "p-gambas-ajillo",
    categoria_id: "cat-tapas",
    nombre: "Gambas al ajillo",
    descripcion: "Gambas salteadas en aceite de oliva, ajo y guindilla, con pan para mojar.",
    precio: 1250,
    destacado: true,
    orden: 1,
    alergenos: ["crustáceos", "gluten"],
  }),
  producto({
    id: "p-croquetas",
    categoria_id: "cat-tapas",
    nombre: "Croquetas caseras de jamón ibérico",
    descripcion: "Bechamel cremosa de jamón ibérico, fritas al momento (6 unidades).",
    precio: 950,
    destacado: true,
    orden: 2,
    alergenos: ["gluten", "lácteos", "huevo"],
  }),
  producto({
    id: "p-pulpo",
    categoria_id: "cat-tapas",
    nombre: "Pulpo a la brasa con puré de patata trufado",
    descripcion: "Pulpo cocido a baja temperatura y terminado a la brasa, pimentón de la Vera.",
    precio: 1650,
    destacado: true,
    orden: 3,
    alergenos: ["moluscos"],
  }),
  producto({
    id: "p-jamon-iberico",
    categoria_id: "cat-tapas",
    nombre: "Tabla de jamón ibérico de bellota",
    descripcion: "Cortado a cuchillo, con pan de cristal y tomate.",
    precio: 1600,
    orden: 4,
    alergenos: ["gluten"],
  }),
  producto({
    id: "p-pan-tumaca",
    categoria_id: "cat-tapas",
    nombre: "Pan con tomate y queso mahonés",
    descripcion: "Pan de payés, tomate de temporada y queso curado de Menorca.",
    precio: 750,
    orden: 5,
    alergenos: ["gluten", "lácteos"],
  }),
  producto({
    id: "p-tartar-atun",
    categoria_id: "cat-tapas",
    nombre: "Tartar de atún rojo con aguacate",
    descripcion: "Atún rojo del Mediterráneo, aguacate, soja y sésamo tostado.",
    precio: 1450,
    orden: 6,
    alergenos: ["pescado", "soja", "sésamo"],
  }),

  // Raciones
  producto({
    id: "p-calamares",
    categoria_id: "cat-raciones",
    nombre: "Calamar a la plancha con alioli",
    descripcion: "Calamar fresco a la plancha, alioli casero y limón.",
    precio: 1650,
    orden: 1,
    alergenos: ["moluscos", "huevo"],
  }),
  producto({
    id: "p-solomillo",
    categoria_id: "cat-raciones",
    nombre: "Solomillo de cerdo al whisky",
    descripcion: "Medallones de solomillo salteados con salsa de whisky y patatas panadera.",
    precio: 1550,
    orden: 2,
  }),
  producto({
    id: "p-ensaladilla",
    categoria_id: "cat-raciones",
    nombre: "Ensaladilla rusa de la casa",
    descripcion: "Receta tradicional con bonito y aceitunas.",
    precio: 850,
    orden: 3,
    alergenos: ["huevo", "pescado"],
  }),
  producto({
    id: "p-berenjenas-miel",
    categoria_id: "cat-raciones",
    nombre: "Berenjenas fritas con miel de caña",
    descripcion: "Bastones de berenjena crujiente con miel de caña.",
    precio: 850,
    orden: 4,
    alergenos: ["gluten"],
  }),

  // Frituras
  producto({
    id: "p-boquerones",
    categoria_id: "cat-frituras",
    nombre: "Boquerones fritos",
    descripcion: "Boquerones frescos rebozados en harina fina y fritos al momento.",
    precio: 950,
    orden: 1,
    alergenos: ["pescado", "gluten"],
  }),
  producto({
    id: "p-calamares-fritos",
    categoria_id: "cat-frituras",
    nombre: "Calamares a la andaluza",
    descripcion: "Rabas de calamar fresco, rebozadas y fritas, con alioli.",
    precio: 1350,
    orden: 2,
    alergenos: ["moluscos", "gluten", "huevo"],
  }),
  producto({
    id: "p-fritura-pescado",
    categoria_id: "cat-frituras",
    nombre: "Fritura mixta de pescado de la lonja",
    descripcion: "Selección de pescado de temporada, freído en aceite de oliva.",
    precio: 1650,
    destacado: true,
    orden: 3,
    alergenos: ["pescado", "gluten"],
  }),

  // Hamburguesas
  producto({
    id: "p-hamburguesa-osa",
    categoria_id: "cat-hamburguesas",
    nombre: "Hamburguesa La Osa",
    descripcion:
      "200g de vacuno mallorquín, queso mahonés, cebolla caramelizada y salsa de la casa.",
    precio: 1450,
    destacado: true,
    orden: 1,
    alergenos: ["gluten", "lácteos"],
  }),
  producto({
    id: "p-hamburguesa-iberica",
    categoria_id: "cat-hamburguesas",
    nombre: "Hamburguesa ibérica",
    descripcion: "Vacuno, panceta ibérica crujiente, huevo y queso curado.",
    precio: 1550,
    orden: 2,
    alergenos: ["gluten", "lácteos", "huevo"],
  }),
  producto({
    id: "p-hamburguesa-veggie",
    categoria_id: "cat-hamburguesas",
    nombre: "Hamburguesa vegetal de garbanzos y verduras asadas",
    descripcion: "Con hummus de la casa, rúcula y tomate confitado.",
    precio: 1350,
    orden: 3,
    alergenos: ["gluten"],
  }),

  // Bocadillos
  producto({
    id: "p-bocadillo-calamares",
    categoria_id: "cat-bocadillos",
    nombre: "Bocadillo de calamares",
    descripcion: "Clásico bocadillo de calamares a la andaluza con alioli.",
    precio: 950,
    orden: 1,
    alergenos: ["moluscos", "gluten", "huevo"],
  }),
  producto({
    id: "p-bocadillo-lomo",
    categoria_id: "cat-bocadillos",
    nombre: "Bocadillo de lomo con queso y pimientos",
    descripcion: "Lomo de cerdo a la plancha, queso fundido y pimientos asados.",
    precio: 950,
    orden: 2,
    alergenos: ["gluten", "lácteos"],
  }),
  producto({
    id: "p-bocadillo-jamon",
    categoria_id: "cat-bocadillos",
    nombre: "Bocadillo de jamón ibérico",
    descripcion: "Pan de payés con jamón ibérico y aceite de oliva virgen extra.",
    precio: 1050,
    orden: 3,
    alergenos: ["gluten"],
  }),

  // Menú diario
  producto({
    id: "p-menu-diario",
    categoria_id: "cat-menu-diario",
    nombre: "Menú Diario",
    descripcion:
      "Entrante + plato principal + postre o café. Cambia cada día según mercado y temporada — pregunta en sala. Disponible mediodías, viernes a miércoles.",
    precio: 1450,
    destacado: true,
    orden: 1,
  }),

  // Bebidas
  producto({
    id: "p-agua",
    categoria_id: "cat-bebidas",
    nombre: "Agua mineral",
    descripcion: "50 cl.",
    precio: 250,
    orden: 1,
  }),
  producto({
    id: "p-refresco",
    categoria_id: "cat-bebidas",
    nombre: "Refrescos",
    descripcion: "Selección de refrescos.",
    precio: 300,
    orden: 2,
  }),
  producto({
    id: "p-zumo-naranja",
    categoria_id: "cat-bebidas",
    nombre: "Zumo de naranja natural",
    descripcion: "Recién exprimido.",
    precio: 400,
    orden: 3,
  }),
  producto({
    id: "p-cafe",
    categoria_id: "cat-bebidas",
    nombre: "Café",
    descripcion: "Solo, cortado, con leche o americano.",
    precio: 200,
    orden: 4,
  }),

  // Cervezas
  producto({
    id: "p-cerveza-caña",
    categoria_id: "cat-cervezas",
    nombre: "Caña",
    descripcion: "Cerveza de barril, 20 cl.",
    precio: 300,
    orden: 1,
    alergenos: ["gluten"],
  }),
  producto({
    id: "p-cerveza-mallorquina",
    categoria_id: "cat-cervezas",
    nombre: "Cerveza artesana mallorquina",
    descripcion: "Botellín de una cervecera local.",
    precio: 450,
    destacado: true,
    orden: 2,
    alergenos: ["gluten"],
  }),
  producto({
    id: "p-cerveza-sinalcohol",
    categoria_id: "cat-cervezas",
    nombre: "Cerveza sin alcohol",
    descripcion: "Botellín 33 cl.",
    precio: 350,
    orden: 3,
    alergenos: ["gluten"],
  }),

  // Vinos
  producto({
    id: "p-vino-blanco",
    categoria_id: "cat-vinos",
    nombre: "Copa de vino blanco mallorquín",
    descripcion: "D.O. Binissalem o Pla i Llevant, según cosecha.",
    precio: 500,
    orden: 1,
  }),
  producto({
    id: "p-vino-tinto",
    categoria_id: "cat-vinos",
    nombre: "Copa de vino tinto",
    descripcion: "Selección de bodegas mallorquinas y peninsulares.",
    precio: 500,
    orden: 2,
  }),
  producto({
    id: "p-vino-rosado",
    categoria_id: "cat-vinos",
    nombre: "Copa de vino rosado",
    descripcion: "Fresco, ideal para la terraza.",
    precio: 500,
    orden: 3,
  }),
  producto({
    id: "p-cava",
    categoria_id: "cat-vinos",
    nombre: "Copa de cava",
    descripcion: "Brut nature.",
    precio: 550,
    orden: 4,
  }),
];

/** Sin reseñas todavía: es una marca nueva en la web, no se inventan
 * testimonios de clientes. ReviewsSection/opiniones ya manejan el caso
 * vacío con un mensaje honesto en vez de romperse. */
export const RESENAS: ResenaPublica[] = [];

/**
 * Sin reportaje fotográfico real todavía (ver GaleriaPage): en vez de
 * reutilizar las fotos reales de otro negocio, estas páginas usan un
 * tratamiento visual editorial (color/tipografía) hasta que exista
 * fotografía propia de La Osa.
 */
export const SITE_IMAGES = null;
