-- TicketBAI / Batuz (Bizkaia) — esquema y RPC base.
-- NO aplicado todavía (a diferencia del resto de ficheros de esta carpeta). Preparado para
-- revisión antes de ejecutarlo vía MCP en el proyecto Supabase compartido (ukhfaphloxlszomccgde).
--
-- Contexto: Palomita Bar SL (NIF 22756634C, Barakaldo, Bizkaia) todavía no tiene certificado
-- digital ni número de alta-inscripción TBAI. Este esquema deja preparada la numeración
-- correlativa, el encadenamiento entre facturas y el almacenamiento del fichero TBAI, para que
-- el día que haya certificado solo haga falta implementar la firma XAdES real (ver
-- src/lib/ticketbai/firma.ts) y el envío (src/lib/ticketbai/envio.ts). Hasta entonces, el
-- módulo TS no llama a ninguna de estas funciones si TICKETBAI_ENABLED no es "true".

-- 1. Tabla de facturas TicketBAI. Solo lectura para el tenant/admin vía RLS; toda escritura
--    pasa por las RPC de abajo (SECURITY DEFINER, concedidas solo a service_role), igual que
--    marcar_pedido_pagado — el registro fiscal no debe poder tocarse desde el cliente.
create table restaurant.ticketbai_facturas (
  id uuid primary key default gen_random_uuid(),
  cliente_id uuid not null references public.clientes(id),
  pedido_ids uuid[] not null,
  mesa_id uuid references restaurant.mesas(id),

  serie text not null,
  numero integer not null,
  fecha_expedicion date not null,
  hora_expedicion time not null,

  nif_emisor text not null,
  razon_social_emisor text not null,
  descripcion text not null default 'Consumición hostelería',
  importe_total_centimos integer not null,
  -- [{ tipo_impositivo: 10.00, base_imponible_centimos, cuota_centimos }, ...]
  desglose_iva jsonb not null,
  -- [{ descripcion, cantidad, importe_unitario_centimos, importe_total_centimos, tipo_impositivo }, ...]
  lineas jsonb not null,

  encadenamiento_serie_anterior text,
  encadenamiento_numero_anterior integer,
  encadenamiento_fecha_anterior date,
  encadenamiento_firma_anterior text,

  identificativo_tbai text,
  qr_url text,
  xml_sin_firmar text,
  xml_firmado text,
  signature_value text,

  estado text not null default 'BORRADOR'
    check (estado in ('BORRADOR', 'FIRMADA', 'ENVIADA', 'ERROR', 'ANULADA')),
  error_mensaje text,
  enviado_at timestamptz,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  unique (cliente_id, serie, numero)
);

create index ticketbai_facturas_cliente_idx on restaurant.ticketbai_facturas (cliente_id, serie, numero desc);
create index ticketbai_facturas_pedido_ids_idx on restaurant.ticketbai_facturas using gin (pedido_ids);

alter table restaurant.ticketbai_facturas enable row level security;

create policy ticketbai_facturas_select on restaurant.ticketbai_facturas
  for select
  using (is_developer() or cliente_id = mi_cliente_id());

-- Deliberadamente sin políticas de insert/update/delete: ni el tenant-admin ni is_developer
-- pueden escribir directamente. Solo las RPC de abajo (service_role) pueden mutar esta tabla.

-- 2. Helper de autorización para la ruta API (mismo patrón que puede_ver_premio_admin):
--    SECURITY INVOKER, se apoya en la RLS ya existente de restaurant.mesas.
create or replace function public.puede_gestionar_mesa_admin(p_mesa_id uuid)
returns boolean
language sql
stable
set search_path to 'public', 'restaurant'
as $function$
  select exists (select 1 from restaurant.mesas where id = p_mesa_id);
$function$;

-- 3. Líneas de factura autoritativas: la ruta API nunca confía en precios que le lleguen del
--    navegador, siempre relee de restaurant.pedido_items/productos. SECURITY DEFINER porque la
--    llama el propio backend con el cliente service_role, pero valida p_cliente_id igualmente
--    (defensa en profundidad, igual que el resto de RPC de escritura de este proyecto).
create or replace function public.get_lineas_factura_ticketbai(p_cliente_id uuid, p_pedido_ids uuid[])
returns jsonb
language sql
stable
security definer
set search_path to 'public', 'restaurant'
as $function$
  select coalesce(jsonb_agg(jsonb_build_object(
    'descripcion', p.nombre,
    'cantidad', oi.cantidad,
    'importe_unitario_centimos', oi.precio_unitario_centimos,
    'importe_total_centimos', oi.precio_unitario_centimos * oi.cantidad,
    -- Regla fiscal española: bebidas alcohólicas al 21% (tipo general), el resto
    -- (comida y bebidas sin alcohol) al 10% (hostelería). alcohol_pct ya existe en
    -- restaurant.productos (macros/alérgenos); no hace falta columna nueva.
    'tipo_impositivo', case when coalesce(p.alcohol_pct, 0) > 0 then 21.00 else 10.00 end
  ) order by oi.created_at asc), '[]'::jsonb)
  from restaurant.pedido_items oi
  join restaurant.pedidos o on o.id = oi.pedido_id
  join restaurant.productos p on p.id = oi.producto_id
  where o.id = any(p_pedido_ids)
    and o.cliente_id = p_cliente_id;
$function$;

revoke execute on function public.get_lineas_factura_ticketbai from public, anon, authenticated;
grant execute on function public.get_lineas_factura_ticketbai to service_role;

-- 4. Idempotencia: "Imprimir cuenta" se puede pulsar varias veces antes de liberar la mesa
--    (es solo una vista previa impresa, no hay un paso explícito de "cerrar cuenta" separado
--    en el flujo actual de SalonBoard). TicketBAI prohíbe volver a emitir una factura ya
--    generada — un reintento debe reutilizar la misma factura y el ticket debe marcarse como
--    "duplicado" (sección 6.1 de las especificaciones TicketBAI 1.2). Por eso, antes de crear
--    una factura nueva, se busca si ya existe una para este mismo conjunto de pedidos.
-- Devuelve jsonb (objeto único o null), no el tipo compuesto crudo: mismo criterio que el
-- resto de RPC públicas de este proyecto (get_mesas_estado_admin, get_lineas_factura_ticketbai...),
-- para no depender de cómo PostgREST serializa un composite type de un schema no expuesto.
create or replace function public.buscar_factura_ticketbai_por_pedidos(p_cliente_id uuid, p_pedido_ids uuid[])
returns jsonb
language sql
stable
security definer
set search_path to 'public', 'restaurant'
as $function$
  select to_jsonb(t)
  from (
    select *
    from restaurant.ticketbai_facturas
    where cliente_id = p_cliente_id
      and estado in ('FIRMADA', 'ENVIADA')
      and pedido_ids <@ p_pedido_ids
      and pedido_ids && p_pedido_ids
    order by created_at desc
    limit 1
  ) t;
$function$;

revoke execute on function public.buscar_factura_ticketbai_por_pedidos from public, anon, authenticated;
grant execute on function public.buscar_factura_ticketbai_por_pedidos to service_role;

-- 5. Alta de una factura nueva: asigna número correlativo y datos de encadenamiento de forma
--    atómica (pg_advisory_xact_lock evita que dos cierres de mesa simultáneos se lleven el
--    mismo número). Devuelve la fila completa en estado BORRADOR; el XML/firma/QR se rellenan
--    después con actualizar_factura_ticketbai, una vez firmado.
create or replace function public.crear_factura_ticketbai(
  p_cliente_id uuid,
  p_pedido_ids uuid[],
  p_mesa_id uuid,
  p_serie text,
  p_nif_emisor text,
  p_razon_social_emisor text,
  p_descripcion text,
  p_importe_total_centimos integer,
  p_desglose_iva jsonb,
  p_lineas jsonb
)
-- Devuelve jsonb, no el tipo compuesto crudo (ver comentario en buscar_factura_ticketbai_por_pedidos).
returns jsonb
language plpgsql
security definer
set search_path to 'public', 'restaurant'
as $function$
declare
  v_anterior restaurant.ticketbai_facturas;
  v_numero integer;
  v_row restaurant.ticketbai_facturas;
begin
  if exists (
    select 1 from restaurant.pedidos
    where id = any(p_pedido_ids) and cliente_id <> p_cliente_id
  ) then
    raise exception 'Alguno de los pedidos no pertenece al cliente indicado';
  end if;

  -- Serializa por cliente+serie: dos mesas cerrándose a la vez no pueden llevarse el mismo
  -- número ni un hueco en el encadenamiento.
  perform pg_advisory_xact_lock(hashtextextended(p_cliente_id::text || '|' || p_serie, 0));

  select * into v_anterior
  from restaurant.ticketbai_facturas
  where cliente_id = p_cliente_id and serie = p_serie and estado in ('FIRMADA', 'ENVIADA')
  order by numero desc
  limit 1;

  v_numero := coalesce(v_anterior.numero, 0) + 1;

  insert into restaurant.ticketbai_facturas (
    cliente_id, pedido_ids, mesa_id, serie, numero, fecha_expedicion, hora_expedicion,
    nif_emisor, razon_social_emisor, descripcion, importe_total_centimos,
    desglose_iva, lineas,
    encadenamiento_serie_anterior, encadenamiento_numero_anterior,
    encadenamiento_fecha_anterior, encadenamiento_firma_anterior,
    estado
  ) values (
    p_cliente_id, p_pedido_ids, p_mesa_id, p_serie, v_numero,
    (now() at time zone 'Europe/Madrid')::date, (now() at time zone 'Europe/Madrid')::time,
    p_nif_emisor, p_razon_social_emisor, p_descripcion, p_importe_total_centimos,
    p_desglose_iva, p_lineas,
    v_anterior.serie, v_anterior.numero, v_anterior.fecha_expedicion,
    case when v_anterior.signature_value is not null then left(v_anterior.signature_value, 100) else null end,
    'BORRADOR'
  )
  returning * into v_row;

  return to_jsonb(v_row);
end;
$function$;

revoke execute on function public.crear_factura_ticketbai from public, anon, authenticated;
grant execute on function public.crear_factura_ticketbai to service_role;

-- 6. Tras generar/firmar el XML: guarda el resultado. p_estado = 'ERROR' deja constancia de un
--    intento fallido sin perder el número ya asignado (evita reutilizar el número, evita
--    también fingir que la factura se emitió si la firma o el envío fallaron).
create or replace function public.actualizar_factura_ticketbai(
  p_id uuid,
  p_estado text,
  p_identificativo_tbai text default null,
  p_qr_url text default null,
  p_xml_sin_firmar text default null,
  p_xml_firmado text default null,
  p_signature_value text default null,
  p_error_mensaje text default null
)
returns void
language sql
security definer
set search_path to 'public', 'restaurant'
as $function$
  update restaurant.ticketbai_facturas
  set estado = p_estado,
      identificativo_tbai = coalesce(p_identificativo_tbai, identificativo_tbai),
      qr_url = coalesce(p_qr_url, qr_url),
      xml_sin_firmar = coalesce(p_xml_sin_firmar, xml_sin_firmar),
      xml_firmado = coalesce(p_xml_firmado, xml_firmado),
      signature_value = coalesce(p_signature_value, signature_value),
      error_mensaje = p_error_mensaje,
      enviado_at = case when p_estado = 'ENVIADA' then now() else enviado_at end,
      updated_at = now()
  where id = p_id;
$function$;

revoke execute on function public.actualizar_factura_ticketbai from public, anon, authenticated;
grant execute on function public.actualizar_factura_ticketbai to service_role;

-- 7. get_mesas_estado_admin: añade producto_id y alcohol_pct por línea (además de lo que ya
--    devolvía) para que el panel pueda, en el futuro, mostrar el desglose de IVA real en el
--    ticket sin otra ida y vuelta al servidor. CREATE OR REPLACE aditivo, no quita nada de lo
--    que ya había.
create or replace function public.get_mesas_estado_admin(p_cliente_id uuid, p_fecha date default ((now() at time zone 'Europe/Madrid'))::date)
returns jsonb
language sql
stable
set search_path to 'public', 'restaurant'
as $function$
  select coalesce(jsonb_agg(row_to_json(t) order by
    coalesce(substring(t.numero from '^[A-Za-z]*'), ''),
    coalesce(nullif(substring(t.numero from '\d+'), '')::int, 0),
    t.numero
  ), '[]'::jsonb)
  from (
    select
      m.id,
      m.numero,
      m.nombre,
      m.identificador,
      m.activa,
      m.ocupada,
      m.pos_x,
      m.pos_y,
      m.zona_id,
      m.capacidad,
      m.camarero_id,
      c.nombre as camarero_nombre,
      m.clientes_sentados,
      m.entrada_at,
      m.pagando,
      m.pagando_at,
      m.por_limpiar,
      m.union_grupo_id,
      m.nota,
      m.aviso_camarero_at,
      (
        select s.modo from restaurant.mesa_sesiones s
        where s.mesa_id = m.id and s.estado = 'ACTIVA'
      ) as sesion_modo,
      (
        select coalesce(jsonb_agg(jsonb_build_object(
          'id', o.id,
          'estado', o.estado,
          'payment_method', o.payment_method,
          'payment_status', o.payment_status,
          'total_centimos', o.total_centimos,
          'notas', o.notas,
          'created_at', o.created_at,
          'participante_nombre', sp.nombre,
          'items', (
            select coalesce(jsonb_agg(jsonb_build_object(
              'producto_id', p.id,
              'producto_nombre', p.nombre,
              'alcohol_pct', p.alcohol_pct,
              'cantidad', oi.cantidad,
              'precio_unitario_centimos', oi.precio_unitario_centimos,
              'notas', oi.notas
            ) order by oi.created_at asc), '[]'::jsonb)
            from restaurant.pedido_items oi
            join restaurant.productos p on p.id = oi.producto_id
            where oi.pedido_id = o.id
          )
        ) order by o.created_at asc), '[]'::jsonb)
        from restaurant.pedidos o
        left join restaurant.sesion_participantes sp on sp.id = o.participante_id
        where o.mesa_id = m.id
          and o.created_at >= (p_fecha::timestamp at time zone 'Europe/Madrid')
          and o.created_at < ((p_fecha + 1)::timestamp at time zone 'Europe/Madrid')
          and o.estado != 'CANCELLED'
      ) as pedidos_hoy
    from restaurant.mesas m
    left join restaurant.camareros c on c.id = m.camarero_id
    where m.cliente_id = p_cliente_id
  ) t;
$function$;
