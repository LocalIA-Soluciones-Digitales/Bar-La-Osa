-- Hace que crear_pedido_restaurant (la función que fija el precio real que
-- se cobra por cada pedido) cobre según la tarifa de la mesa: barra, salón
-- o terraza, en vez de un único precio para todos.
--
-- Cambio mínimo sobre la versión actual (la de 7 argumentos, la única que
-- llama la app — ver public.crear_pedido_restaurant(p_site_key uuid,
-- p_items jsonb, p_payment_method text, p_mesa_identificador text,
-- p_notas text, p_sesion_id uuid, p_participante_id uuid)):
--   1. Tras resolver la mesa (por identificador o por sesión), se busca el
--      nombre de su zona y se decide la tarifa con el mismo criterio que ya
--      usa la app (src/lib/restaurant/precio-zona.ts): contiene "terraza" →
--      terraza; contiene "bar" → barra; si no, salón. Sin mesa (pedido de
--      barra física, p. ej. desde BarraPOS) → tarifa barra directamente.
--   2. Al insertar cada línea del pedido, el precio ya no sale siempre de
--      precio_centimos: sale de precio_barra_centimos / precio_salon_centimos
--      / precio_terraza_centimos según la tarifa, con precio_centimos como
--      respaldo si el producto no tiene esas columnas fijadas (NULL).
-- No se toca la lógica de sesión, reparto entre comensales ni ninguna otra
-- validación existente.

CREATE OR REPLACE FUNCTION public.crear_pedido_restaurant(p_site_key uuid, p_items jsonb, p_payment_method text, p_mesa_identificador text DEFAULT NULL::text, p_notas text DEFAULT NULL::text, p_sesion_id uuid DEFAULT NULL::uuid, p_participante_id uuid DEFAULT NULL::uuid)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public', 'restaurant'
AS $function$
declare
  v_cliente_id uuid;
  v_mesa restaurant.mesas;
  v_mesa_id uuid;
  v_sesion restaurant.mesa_sesiones;
  v_participante restaurant.sesion_participantes;
  v_pedido_id uuid;
  v_item jsonb;
  v_reparto jsonb;
  v_producto restaurant.productos;
  v_cantidad integer;
  v_subtotal integer := 0;
  v_item_subtotal integer;
  v_reparto_suma integer;
  v_pedido_item_id uuid;
  v_zona_nombre text;
  v_tarifa text;
  v_precio integer;
begin
  v_cliente_id := public.cliente_id_from_site_key(p_site_key);
  if v_cliente_id is null then
    raise exception 'site_key inválida';
  end if;

  if p_payment_method not in ('ONLINE', 'LOCAL') then
    raise exception 'Método de pago no válido';
  end if;

  if p_sesion_id is not null then
    select * into v_sesion from restaurant.mesa_sesiones
    where id = p_sesion_id and cliente_id = v_cliente_id and estado = 'ACTIVA';

    if v_sesion.id is null then
      raise exception 'Sesión de mesa no válida o cerrada';
    end if;

    v_mesa_id := v_sesion.mesa_id;

    if p_participante_id is not null then
      select * into v_participante from restaurant.sesion_participantes
      where id = p_participante_id and sesion_id = v_sesion.id;

      if v_participante.id is null then
        raise exception 'Comensal no válido para esta sesión';
      end if;
    end if;
  elsif p_mesa_identificador is not null and p_mesa_identificador != '' then
    select * into v_mesa from restaurant.mesas
    where cliente_id = v_cliente_id
    and identificador = p_mesa_identificador
    and activa = true;

    if v_mesa.id is null then
      raise exception 'Mesa no válida o inactiva';
    end if;

    v_mesa_id := v_mesa.id;
  end if;

  if p_items is null or jsonb_array_length(p_items) = 0 then
    raise exception 'El pedido no tiene productos';
  end if;

  -- Tarifa según la zona de la mesa (barra/salón/terraza). Sin mesa
  -- (pedido de barra física) se usa directamente la tarifa "barra".
  if v_mesa_id is not null then
    select lower(z.nombre) into v_zona_nombre
    from restaurant.mesas m
    left join restaurant.zonas z on z.id = m.zona_id
    where m.id = v_mesa_id;

    v_tarifa := case
      when v_zona_nombre like '%terraza%' then 'terraza'
      when v_zona_nombre like '%bar%' then 'barra'
      else 'salon'
    end;
  else
    v_tarifa := 'barra';
  end if;

  insert into restaurant.pedidos (cliente_id, mesa_id, payment_method, notas, sesion_id, participante_id)
  values (v_cliente_id, v_mesa_id, p_payment_method, p_notas, p_sesion_id, p_participante_id)
  returning id into v_pedido_id;

  for v_item in select * from jsonb_array_elements(p_items)
  loop
    select * into v_producto from restaurant.productos
    where id = (v_item->>'producto_id')::uuid
    and cliente_id = v_cliente_id
    and disponible = true;

    if v_producto.id is null then
      raise exception 'Producto no disponible: %', v_item->>'producto_id';
    end if;

    v_cantidad := coalesce((v_item->>'cantidad')::integer, 1);
    if v_cantidad <= 0 then
      raise exception 'Cantidad inválida para el producto %', v_producto.nombre;
    end if;

    v_precio := case v_tarifa
      when 'barra' then coalesce(v_producto.precio_barra_centimos, v_producto.precio_centimos)
      when 'terraza' then coalesce(v_producto.precio_terraza_centimos, v_producto.precio_centimos)
      else coalesce(v_producto.precio_salon_centimos, v_producto.precio_centimos)
    end;

    insert into restaurant.pedido_items (pedido_id, producto_id, cantidad, precio_unitario_centimos, notas, modificadores)
    values (
      v_pedido_id,
      v_producto.id,
      v_cantidad,
      v_precio,
      v_item->>'notas',
      coalesce(v_item->'modificadores', '[]'::jsonb)
    )
    returning id into v_pedido_item_id;

    v_item_subtotal := v_precio * v_cantidad;
    v_subtotal := v_subtotal + v_item_subtotal;

    -- Reparto entre comensales: solo tiene sentido dentro de una sesión de
    -- mesa. Si el item no trae reparto explícito, se atribuye entero a
    -- quien lo pidió (o no se reparte si el pedido no tiene sesión).
    if v_sesion.id is not null then
      if v_item ? 'reparto' and jsonb_array_length(v_item->'reparto') > 0 then
        v_reparto_suma := 0;
        for v_reparto in select * from jsonb_array_elements(v_item->'reparto')
        loop
          if not exists (
            select 1 from restaurant.sesion_participantes
            where id = (v_reparto->>'participante_id')::uuid and sesion_id = v_sesion.id
          ) then
            raise exception 'Reparto con comensal fuera de esta sesión';
          end if;

          insert into restaurant.pedido_item_repartos (pedido_item_id, participante_id, importe_centimos)
          values (
            v_pedido_item_id,
            (v_reparto->>'participante_id')::uuid,
            (v_reparto->>'importe_centimos')::integer
          );

          v_reparto_suma := v_reparto_suma + (v_reparto->>'importe_centimos')::integer;
        end loop;

        if v_reparto_suma != v_item_subtotal then
          raise exception 'El reparto de % (%) no coincide con el subtotal de la línea (%)',
            v_producto.nombre, v_reparto_suma, v_item_subtotal;
        end if;
      elsif p_participante_id is not null then
        insert into restaurant.pedido_item_repartos (pedido_item_id, participante_id, importe_centimos)
        values (v_pedido_item_id, p_participante_id, v_item_subtotal);
      end if;
    end if;
  end loop;

  update restaurant.pedidos
  set subtotal_centimos = v_subtotal, total_centimos = v_subtotal
  where id = v_pedido_id;

  return v_pedido_id;
end;
$function$
;
