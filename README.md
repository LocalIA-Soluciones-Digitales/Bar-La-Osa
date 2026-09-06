# Bar de Tapas La Osa

Web de Bar de Tapas La Osa, en Port d'Alcúdia (Mallorca): tapas mediterráneas,
menú diario, terraza y reservas.

Este proyecto reutiliza la arquitectura completa de una plataforma de
hostelería ya construida (pedido en mesa, cocina en vivo, TPV de barra,
reservas, TicketBAI/Batuz) — ver [`ARCHITECTURE.md`](./ARCHITECTURE.md) para
la historia técnica completa de esa plataforma (incluye el desarrollo
original, hecho para otro negocio, del que hereda toda la infraestructura).
La identidad de marca, contenidos y textos públicos son propios de La Osa.

## Stack

- Next.js (App Router) + TypeScript + Tailwind CSS
- Supabase (Postgres, Auth, Storage, Realtime) — infraestructura multi-tenant compartida
- Stripe Checkout + Webhooks
- Vercel

## Desarrollo

```bash
npm install
npm run dev
```

Copia `.env.example` a `.env.local` y rellena las variables.

## Estado

La Osa está dada de alta como tenant nuevo (fila en `public.clientes`,
`slug = 'bar-la-osa'`) del mismo vertical "restaurant" que ya usaba Palomita
Bar — mismo schema `restaurant.*`, mismo patrón `site_key`/RPC, sin tocar
nada de los tenants existentes. Ver `ARCHITECTURE.md` para el diseño
multi-tenant original y `supabase/la_osa_alta_tenant_2026-09-06.sql` para la
migración exacta aplicada (carta sembrada como contenido de referencia
inicial: 11 categorías, 38 productos, editable desde `/admin/carta`).

La capa pública (home, carta, bebidas, opiniones, reservas) y el panel
`/admin` (POS, cocina, mesas, fidelización) ya leen y escriben datos reales
de ese tenant vía las RPC de `src/lib/restaurant/queries.ts` /
`admin-queries.ts`. Necesitan las variables `NEXT_PUBLIC_SUPABASE_URL`,
`NEXT_PUBLIC_SUPABASE_ANON_KEY`, `NEXT_PUBLIC_LAOSA_SITE_KEY` y
`NEXT_PUBLIC_LAOSA_CLIENTE_ID` configuradas (ver `.env.example`) — sin
ellas, la web pública sigue funcionando (la home/carta/etc. no rompen,
solo no muestran datos) y `/admin` no es accesible.

El módulo TicketBAI/Batuz permanece desactivado (`TICKETBAI_ENABLED=false`)
— es específico del País Vasco y no aplica a un negocio de Baleares sin
adaptación; no se ha inventado ningún dato fiscal (NIF, razón social).

Pendiente de decisión del usuario (no técnico): teléfono e Instagram
públicos reales (no confirmados, por eso no aparecen todavía en la web),
fotografía real del local para sustituir los tratamientos de color de
portada/galería, y revisar/editar la carta sembrada desde `/admin/carta`
con el menú y precios reales.
