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

La capa pública (home, carta, bebidas, galería, reservas, opiniones) usa
contenido de referencia estático (`src/lib/restaurant/static-content.ts`)
mientras no exista un tenant Supabase real dado de alta para La Osa. Las
funciones RPC (`src/lib/restaurant/queries.ts`) están intactas y listas para
reconectarse en cuanto exista ese tenant — ver `ARCHITECTURE.md` para el
patrón de aislamiento multi-tenant reutilizado.

El panel `/admin` (POS, cocina, mesas, fidelización) conserva toda su lógica
y solo se ha renombrado la marca visible; sigue necesitando ese mismo tenant
para tener datos reales. El módulo TicketBAI/Batuz permanece desactivado
(`TICKETBAI_ENABLED=false`) — es específico del País Vasco y no aplica a un
negocio de Baleares sin adaptación; no se ha inventado ningún dato fiscal.

Pendiente de decisión del usuario (no técnico): teléfono e Instagram
públicos reales (no confirmados, por eso no aparecen todavía en la web),
fotografía real del local para sustituir los tratamientos de color de
portada/galería, y alta del tenant en Supabase cuando se quiera conectar
carta/reservas/reseñas a datos reales.
