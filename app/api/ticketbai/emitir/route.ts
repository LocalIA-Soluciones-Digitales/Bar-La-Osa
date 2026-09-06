import { NextResponse } from "next/server";
import { createSupabaseServerClient } from "@/lib/supabase/server";
import { createSupabaseServiceRoleClient } from "@/lib/supabase/service-role";
import { emitirFacturaTicketBai } from "@/lib/ticketbai";
import { SITE } from "@/lib/constants";

export const runtime = "nodejs";
export const dynamic = "force-dynamic";

const LAOSA_CLIENTE_ID = process.env.NEXT_PUBLIC_LAOSA_CLIENTE_ID;

interface EmitirBody {
  mesaId?: string;
  pedidoIds?: string[];
}

// Se llama al pulsar "Imprimir cuenta" en /admin (SalonBoard.tsx). Autenticado por la sesión
// del encargado (mismo patrón que app/api/admin/premios/[id]/reenviar/route.ts) — no por el
// secreto de un webhook, aquí sí hay una persona detrás de la llamada.
//
// No confía en el navegador para nada fiscal: solo recibe qué pedidos facturar, y
// emitirFacturaTicketBai vuelve a leer precios/líneas reales de Supabase antes de generar
// nada (get_lineas_factura_ticketbai). Ver src/lib/ticketbai/index.ts para el porqué de cada
// paso y qué falta (certificado digital, envío a Batuz) antes de que esto haga algo real: hoy
// devuelve { habilitado: false } salvo que TICKETBAI_ENABLED="true" esté puesto a mano.
export async function POST(request: Request) {
  const supabase = await createSupabaseServerClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return NextResponse.json({ error: "No autorizado" }, { status: 401 });
  }

  if (!LAOSA_CLIENTE_ID) {
    return NextResponse.json({ error: "Falta NEXT_PUBLIC_LAOSA_CLIENTE_ID" }, { status: 500 });
  }

  let body: EmitirBody;
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: "Cuerpo de la petición inválido" }, { status: 400 });
  }

  const { mesaId, pedidoIds } = body;
  if (!mesaId || !Array.isArray(pedidoIds) || pedidoIds.length === 0) {
    return NextResponse.json({ error: "Faltan mesaId o pedidoIds" }, { status: 400 });
  }

  const { data: puedeGestionar, error: accesoError } = await supabase.rpc("puede_gestionar_mesa_admin", {
    p_mesa_id: mesaId,
  });
  if (accesoError || !puedeGestionar) {
    return NextResponse.json({ error: "No autorizado" }, { status: 403 });
  }

  const supabaseServiceRole = createSupabaseServiceRoleClient();
  try {
    const resultado = await emitirFacturaTicketBai(supabaseServiceRole, {
      clienteId: LAOSA_CLIENTE_ID,
      mesaId,
      pedidoIds,
      // Sin NIF real confirmado para La Osa todavía (ver TICKETBAI_NIF_EMISOR en
      // .env.example) — irrelevante en la práctica: emitirFacturaTicketBai devuelve
      // { habilitado: false } antes de usar este valor mientras TICKETBAI_ENABLED no
      // sea "true", así que nunca se emite una factura con un NIF vacío o inventado.
      nifEmisor: process.env.TICKETBAI_NIF_EMISOR ?? "",
      // Debe ser la razón social LEGAL registrada del negocio, que puede no coincidir
      // con el nombre comercial de SITE.name — ajustar con TICKETBAI_RAZON_SOCIAL si difiere.
      razonSocialEmisor: process.env.TICKETBAI_RAZON_SOCIAL ?? SITE.name,
    });
    return NextResponse.json(resultado);
  } catch (err) {
    console.error("Error emitiendo factura TicketBAI", err);
    return NextResponse.json({ error: "Error interno emitiendo la factura TicketBAI" }, { status: 500 });
  }
}
