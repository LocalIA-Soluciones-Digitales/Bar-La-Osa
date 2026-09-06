-- Alta de "Bar de Tapas La Osa" como tenant nuevo del vertical "restaurant"
-- (mismo schema reutilizado de Palomita Bar, ver ARCHITECTURE.md). Aplicada
-- vía MCP de Supabase el 2026-09-06. Solo INSERTs aditivos: no se toca
-- ninguna fila de los tenants existentes (Arrantza, Palomita Bar).
--
-- Resultado tras aplicar (verificado):
--   cliente_id = d297b573-28eb-4c5b-9821-4f54523f6bdd
--   site_key   = 734498a5-56e0-4d20-b461-128c1102823a
--   11 categorias, 38 productos, 1 mesa de prueba (numero '1').
--
-- El site_key no es secreto (es la vía pública de acceso, filtrada
-- server-side por las RPC — ver src/lib/restaurant/queries.ts), pero el
-- cliente_id solo se usa autenticado en /admin. Ambos viven en
-- .env.local / variables de entorno de Vercel, no hace falta guardarlos
-- en ningún otro sitio.
do $$
declare
  v_cliente_id uuid;
  v_cat_desayunos uuid;
  v_cat_brunch uuid;
  v_cat_tapas uuid;
  v_cat_raciones uuid;
  v_cat_frituras uuid;
  v_cat_hamburguesas uuid;
  v_cat_bocadillos uuid;
  v_cat_menu_diario uuid;
  v_cat_bebidas uuid;
  v_cat_cervezas uuid;
  v_cat_vinos uuid;
begin
  insert into public.clientes (nombre_negocio, slug, tipo_proyecto, estado, notas)
  values (
    'Bar de Tapas La Osa',
    'bar-la-osa',
    'web',
    'activo',
    'Alta como tenant nuevo del vertical "restaurant" (mismo schema reutilizado de Palomita Bar). Sin telefono/instagram/NIF confirmados publicamente todavia -- no rellenar sin confirmar. Carta sembrada como contenido de referencia inicial, editable desde /admin/carta.'
  )
  returning id into v_cliente_id;

  insert into restaurant.categorias (cliente_id, nombre, slug, tipo, orden) values (v_cliente_id, 'Desayunos', 'desayunos', 'comida', 1) returning id into v_cat_desayunos;
  insert into restaurant.categorias (cliente_id, nombre, slug, tipo, orden) values (v_cliente_id, 'Brunch', 'brunch', 'comida', 2) returning id into v_cat_brunch;
  insert into restaurant.categorias (cliente_id, nombre, slug, tipo, orden) values (v_cliente_id, 'Tapas para Compartir', 'tapas', 'comida', 3) returning id into v_cat_tapas;
  insert into restaurant.categorias (cliente_id, nombre, slug, tipo, orden) values (v_cliente_id, 'Raciones', 'raciones', 'comida', 4) returning id into v_cat_raciones;
  insert into restaurant.categorias (cliente_id, nombre, slug, tipo, orden) values (v_cliente_id, 'Frituras', 'frituras', 'comida', 5) returning id into v_cat_frituras;
  insert into restaurant.categorias (cliente_id, nombre, slug, tipo, orden) values (v_cliente_id, 'Hamburguesas Gourmet', 'hamburguesas', 'comida', 6) returning id into v_cat_hamburguesas;
  insert into restaurant.categorias (cliente_id, nombre, slug, tipo, orden) values (v_cliente_id, 'Bocadillos', 'bocadillos', 'comida', 7) returning id into v_cat_bocadillos;
  insert into restaurant.categorias (cliente_id, nombre, slug, tipo, orden) values (v_cliente_id, 'Menú Diario', 'menu-diario', 'comida', 8) returning id into v_cat_menu_diario;
  insert into restaurant.categorias (cliente_id, nombre, slug, tipo, orden) values (v_cliente_id, 'Bebidas', 'bebidas', 'bebida', 1) returning id into v_cat_bebidas;
  insert into restaurant.categorias (cliente_id, nombre, slug, tipo, orden) values (v_cliente_id, 'Cervezas', 'cervezas', 'bebida', 2) returning id into v_cat_cervezas;
  insert into restaurant.categorias (cliente_id, nombre, slug, tipo, orden) values (v_cliente_id, 'Vinos', 'vinos', 'bebida', 3) returning id into v_cat_vinos;

  insert into restaurant.productos (cliente_id, categoria_id, nombre, descripcion, precio_centimos, destacado, alergenos, orden) values
    (v_cliente_id, v_cat_desayunos, 'Tostada de pan payés con tomate y aceite de oliva virgen', 'Pan de payés tostado, tomate de temporada rallado y AOVE mallorquín.', 450, false, array[]::text[], 1),
    (v_cliente_id, v_cat_desayunos, 'Tostada con jamón ibérico y tomate', 'Pan payés, tomate rallado, aceite de oliva virgen extra y jamón ibérico.', 750, false, array['gluten'], 2),
    (v_cliente_id, v_cat_desayunos, 'Huevos rotos con patatas y jamón', 'Huevos camperos rotos sobre patatas fritas al momento y jamón curado.', 850, false, array['huevo'], 3),
    (v_cliente_id, v_cat_desayunos, 'Café y ensaimada mallorquina', 'Ensaimada artesana recién horneada con el café de la casa.', 480, false, array['gluten','huevo'], 4),

    (v_cliente_id, v_cat_brunch, 'Brunch La Osa', 'Huevos al gusto, aguacate, jamón ibérico, tostada de payés y zumo de naranja recién exprimido.', 1450, true, array['gluten','huevo'], 1),
    (v_cliente_id, v_cat_brunch, 'Tostada de aguacate y huevo pochado', 'Aguacate, huevo pochado, semillas tostadas y un toque de guindilla.', 950, false, array['gluten','huevo'], 2),
    (v_cliente_id, v_cat_brunch, 'Bowl de yogur griego, fruta y granola casera', 'Yogur griego, fruta de temporada, granola tostada en casa y miel.', 750, false, array['lácteos','frutos de cáscara'], 3),

    (v_cliente_id, v_cat_tapas, 'Gambas al ajillo', 'Gambas salteadas en aceite de oliva, ajo y guindilla, con pan para mojar.', 1250, true, array['crustáceos','gluten'], 1),
    (v_cliente_id, v_cat_tapas, 'Croquetas caseras de jamón ibérico', 'Bechamel cremosa de jamón ibérico, fritas al momento (6 unidades).', 950, true, array['gluten','lácteos','huevo'], 2),
    (v_cliente_id, v_cat_tapas, 'Pulpo a la brasa con puré de patata trufado', 'Pulpo cocido a baja temperatura y terminado a la brasa, pimentón de la Vera.', 1650, true, array['moluscos'], 3),
    (v_cliente_id, v_cat_tapas, 'Tabla de jamón ibérico de bellota', 'Cortado a cuchillo, con pan de cristal y tomate.', 1600, false, array['gluten'], 4),
    (v_cliente_id, v_cat_tapas, 'Pan con tomate y queso mahonés', 'Pan de payés, tomate de temporada y queso curado de Menorca.', 750, false, array['gluten','lácteos'], 5),
    (v_cliente_id, v_cat_tapas, 'Tartar de atún rojo con aguacate', 'Atún rojo del Mediterráneo, aguacate, soja y sésamo tostado.', 1450, false, array['pescado','soja','sésamo'], 6),

    (v_cliente_id, v_cat_raciones, 'Calamar a la plancha con alioli', 'Calamar fresco a la plancha, alioli casero y limón.', 1650, false, array['moluscos','huevo'], 1),
    (v_cliente_id, v_cat_raciones, 'Solomillo de cerdo al whisky', 'Medallones de solomillo salteados con salsa de whisky y patatas panadera.', 1550, false, array[]::text[], 2),
    (v_cliente_id, v_cat_raciones, 'Ensaladilla rusa de la casa', 'Receta tradicional con bonito y aceitunas.', 850, false, array['huevo','pescado'], 3),
    (v_cliente_id, v_cat_raciones, 'Berenjenas fritas con miel de caña', 'Bastones de berenjena crujiente con miel de caña.', 850, false, array['gluten'], 4),

    (v_cliente_id, v_cat_frituras, 'Boquerones fritos', 'Boquerones frescos rebozados en harina fina y fritos al momento.', 950, false, array['pescado','gluten'], 1),
    (v_cliente_id, v_cat_frituras, 'Calamares a la andaluza', 'Rabas de calamar fresco, rebozadas y fritas, con alioli.', 1350, false, array['moluscos','gluten','huevo'], 2),
    (v_cliente_id, v_cat_frituras, 'Fritura mixta de pescado de la lonja', 'Selección de pescado de temporada, freído en aceite de oliva.', 1650, true, array['pescado','gluten'], 3),

    (v_cliente_id, v_cat_hamburguesas, 'Hamburguesa La Osa', '200g de vacuno mallorquín, queso mahonés, cebolla caramelizada y salsa de la casa.', 1450, true, array['gluten','lácteos'], 1),
    (v_cliente_id, v_cat_hamburguesas, 'Hamburguesa ibérica', 'Vacuno, panceta ibérica crujiente, huevo y queso curado.', 1550, false, array['gluten','lácteos','huevo'], 2),
    (v_cliente_id, v_cat_hamburguesas, 'Hamburguesa vegetal de garbanzos y verduras asadas', 'Con hummus de la casa, rúcula y tomate confitado.', 1350, false, array['gluten'], 3),

    (v_cliente_id, v_cat_bocadillos, 'Bocadillo de calamares', 'Clásico bocadillo de calamares a la andaluza con alioli.', 950, false, array['moluscos','gluten','huevo'], 1),
    (v_cliente_id, v_cat_bocadillos, 'Bocadillo de lomo con queso y pimientos', 'Lomo de cerdo a la plancha, queso fundido y pimientos asados.', 950, false, array['gluten','lácteos'], 2),
    (v_cliente_id, v_cat_bocadillos, 'Bocadillo de jamón ibérico', 'Pan de payés con jamón ibérico y aceite de oliva virgen extra.', 1050, false, array['gluten'], 3),

    (v_cliente_id, v_cat_menu_diario, 'Menú Diario', 'Entrante + plato principal + postre o café. Cambia cada día según mercado y temporada — pregunta en sala. Disponible mediodías, viernes a miércoles.', 1450, true, array[]::text[], 1),

    (v_cliente_id, v_cat_bebidas, 'Agua mineral', '50 cl.', 250, false, array[]::text[], 1),
    (v_cliente_id, v_cat_bebidas, 'Refrescos', 'Selección de refrescos.', 300, false, array[]::text[], 2),
    (v_cliente_id, v_cat_bebidas, 'Zumo de naranja natural', 'Recién exprimido.', 400, false, array[]::text[], 3),
    (v_cliente_id, v_cat_bebidas, 'Café', 'Solo, cortado, con leche o americano.', 200, false, array[]::text[], 4),

    (v_cliente_id, v_cat_cervezas, 'Caña', 'Cerveza de barril, 20 cl.', 300, false, array['gluten'], 1),
    (v_cliente_id, v_cat_cervezas, 'Cerveza artesana mallorquina', 'Botellín de una cervecera local.', 450, true, array['gluten'], 2),
    (v_cliente_id, v_cat_cervezas, 'Cerveza sin alcohol', 'Botellín 33 cl.', 350, false, array['gluten'], 3),

    (v_cliente_id, v_cat_vinos, 'Copa de vino blanco mallorquín', 'D.O. Binissalem o Pla i Llevant, según cosecha.', 500, false, array[]::text[], 1),
    (v_cliente_id, v_cat_vinos, 'Copa de vino tinto', 'Selección de bodegas mallorquinas y peninsulares.', 500, false, array[]::text[], 2),
    (v_cliente_id, v_cat_vinos, 'Copa de vino rosado', 'Fresco, ideal para la terraza.', 500, false, array[]::text[], 3),
    (v_cliente_id, v_cat_vinos, 'Copa de cava', 'Brut nature.', 550, false, array[]::text[], 4);

  insert into restaurant.mesas (cliente_id, numero, nombre, activa, capacidad)
  values (v_cliente_id, '1', 'Mesa de prueba', true, 4);
end $$;
