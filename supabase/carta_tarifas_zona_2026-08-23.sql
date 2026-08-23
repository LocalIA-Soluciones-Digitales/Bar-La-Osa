-- Precios por tarifa (barra / salón / terraza) para la carta TPV de Palomita Bar
-- Generado a partir de fotos del TPV RhynuX (captura 2026-08-22) — 2026-08-23.
-- Regla observada y documentada en carta_actualizacion_2026-08-16.sql: la tarifa
-- de terraza es la tarifa de salón + 0,10€ de suplemento en la práctica totalidad
-- de la carta de bebidas; se ha aplicado ese mismo criterio salvo en las líneas
-- de importe casi nulo (suplementos) donde la foto mostraba el mismo valor.
--
-- IMPORTANTE: no todos los 242 productos de la carta han podido leerse con
-- confianza en las fotos (algunas filas quedaban cortadas por el encuadre o
-- borrosas). Los productos no listados aquí mantienen precio_centimos = 0 y
-- deben revisarse/completarse a mano desde el panel de gestión.

begin;

-- 1. Nuevas columnas de tarifa (si no existen ya)
alter table restaurant.productos
  add column if not exists precio_barra_centimos integer,
  add column if not exists precio_salon_centimos integer,
  add column if not exists precio_terraza_centimos integer;

-- 2. Precios por producto (barra / salón / terraza)
update restaurant.productos p set precio_barra_centimos = 1200, precio_salon_centimos = 1200, precio_terraza_centimos = 1210, precio_centimos = 1200
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'varios' and p.nombre = 'Veggie Roll';
update restaurant.productos p set precio_barra_centimos = 850, precio_salon_centimos = 850, precio_terraza_centimos = 860, precio_centimos = 850
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'varios' and p.nombre = 'Hummus';
update restaurant.productos p set precio_barra_centimos = 900, precio_salon_centimos = 900, precio_terraza_centimos = 910, precio_centimos = 900
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'varios' and p.nombre = 'Nuggets';
update restaurant.productos p set precio_barra_centimos = 850, precio_salon_centimos = 850, precio_terraza_centimos = 860, precio_centimos = 850
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'varios' and p.nombre = 'Patatas Gajo';
update restaurant.productos p set precio_barra_centimos = 1500, precio_salon_centimos = 1500, precio_terraza_centimos = 1510, precio_centimos = 1500
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'varios' and p.nombre = 'Nachos Palomita';
update restaurant.productos p set precio_barra_centimos = 1100, precio_salon_centimos = 1100, precio_terraza_centimos = 1110, precio_centimos = 1100
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'varios' and p.nombre = 'Nachos';
update restaurant.productos p set precio_barra_centimos = 1300, precio_salon_centimos = 1300, precio_terraza_centimos = 1310, precio_centimos = 1300
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'varios' and p.nombre = 'Ensalada Palomita';
update restaurant.productos p set precio_barra_centimos = 1400, precio_salon_centimos = 1400, precio_terraza_centimos = 1410, precio_centimos = 1400
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'varios' and p.nombre = 'Ensalada Ventresca';
update restaurant.productos p set precio_barra_centimos = 1500, precio_salon_centimos = 1500, precio_terraza_centimos = 1510, precio_centimos = 1500
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'varios' and p.nombre = 'Ensalada Burrata';
update restaurant.productos p set precio_barra_centimos = 1900, precio_salon_centimos = 1900, precio_terraza_centimos = 1910, precio_centimos = 1900
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'varios' and p.nombre = 'Tartar de Atún';
update restaurant.productos p set precio_barra_centimos = 900, precio_salon_centimos = 900, precio_terraza_centimos = 910, precio_centimos = 900
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'varios' and p.nombre = 'Gyoza Pollo';
update restaurant.productos p set precio_barra_centimos = 900, precio_salon_centimos = 850, precio_terraza_centimos = 860, precio_centimos = 850
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'varios' and p.nombre = 'Gyoza Vegetal';
update restaurant.productos p set precio_barra_centimos = 900, precio_salon_centimos = 900, precio_terraza_centimos = 910, precio_centimos = 900
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'varios' and p.nombre = 'Pan Bao';
update restaurant.productos p set precio_barra_centimos = 850, precio_salon_centimos = 850, precio_terraza_centimos = 860, precio_centimos = 850
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'varios' and p.nombre = 'Cookie';
update restaurant.productos p set precio_barra_centimos = 750, precio_salon_centimos = 750, precio_terraza_centimos = 760, precio_centimos = 750
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'varios' and p.nombre = 'Coulant';
update restaurant.productos p set precio_barra_centimos = 750, precio_salon_centimos = 750, precio_terraza_centimos = 760, precio_centimos = 750
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'varios' and p.nombre = 'Tarta de Queso';
update restaurant.productos p set precio_barra_centimos = 800, precio_salon_centimos = 800, precio_terraza_centimos = 810, precio_centimos = 800
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'varios' and p.nombre = 'Palomita (especial casa)';
update restaurant.productos p set precio_barra_centimos = 2350, precio_salon_centimos = 2350, precio_terraza_centimos = 2360, precio_centimos = 2350
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'varios' and p.nombre = 'Menú';
update restaurant.productos p set precio_barra_centimos = 200, precio_salon_centimos = 200, precio_terraza_centimos = 210, precio_centimos = 200
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'varios' and p.nombre = 'Pan';
update restaurant.productos p set precio_barra_centimos = 180, precio_salon_centimos = 180, precio_terraza_centimos = 190, precio_centimos = 180
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'varios' and p.nombre = 'Sushi Pote';
update restaurant.productos p set precio_barra_centimos = 80, precio_salon_centimos = 80, precio_terraza_centimos = 80, precio_centimos = 80
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'varios' and p.nombre = 'Suplemento Salsa';
update restaurant.productos p set precio_barra_centimos = 250, precio_salon_centimos = 260, precio_terraza_centimos = 270, precio_centimos = 260
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'varios' and p.nombre = 'Helado';
update restaurant.productos p set precio_barra_centimos = 5, precio_salon_centimos = 5, precio_terraza_centimos = 5, precio_centimos = 5
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'varios' and p.nombre = 'Bolsa';
update restaurant.productos p set precio_barra_centimos = 700, precio_salon_centimos = 700, precio_terraza_centimos = 710, precio_centimos = 700
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'varios' and p.nombre = 'Edamame';
update restaurant.productos p set precio_barra_centimos = 750, precio_salon_centimos = 750, precio_terraza_centimos = 760, precio_centimos = 750
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'varios' and p.nombre = 'Torrija';
update restaurant.productos p set precio_barra_centimos = 900, precio_salon_centimos = 900, precio_terraza_centimos = 910, precio_centimos = 900
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'varios' and p.nombre = 'Rollitos';
update restaurant.productos p set precio_barra_centimos = 850, precio_salon_centimos = 850, precio_terraza_centimos = 860, precio_centimos = 850
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cocteles' and p.nombre = 'Mojito';
update restaurant.productos p set precio_barra_centimos = 850, precio_salon_centimos = 850, precio_terraza_centimos = 860, precio_centimos = 850
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cocteles' and p.nombre = 'Piña Colada';
update restaurant.productos p set precio_barra_centimos = 900, precio_salon_centimos = 900, precio_terraza_centimos = 910, precio_centimos = 900
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cocteles' and p.nombre = 'Dark and Stormy';
update restaurant.productos p set precio_barra_centimos = 800, precio_salon_centimos = 800, precio_terraza_centimos = 810, precio_centimos = 800
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cocteles' and p.nombre = 'Daiquiri';
update restaurant.productos p set precio_barra_centimos = 950, precio_salon_centimos = 950, precio_terraza_centimos = 960, precio_centimos = 950
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cocteles' and p.nombre = 'La Bolsita';
update restaurant.productos p set precio_barra_centimos = 900, precio_salon_centimos = 900, precio_terraza_centimos = 910, precio_centimos = 900
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cocteles' and p.nombre = 'Sex on the Beach';
update restaurant.productos p set precio_barra_centimos = 850, precio_salon_centimos = 850, precio_terraza_centimos = 860, precio_centimos = 850
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cocteles' and p.nombre = 'Expreso Martini';
update restaurant.productos p set precio_barra_centimos = 900, precio_salon_centimos = 900, precio_terraza_centimos = 910, precio_centimos = 900
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cocteles' and p.nombre = 'Mula de Moscú';
update restaurant.productos p set precio_barra_centimos = 800, precio_salon_centimos = 800, precio_terraza_centimos = 810, precio_centimos = 800
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cocteles' and p.nombre = 'Cosmopolitan';
update restaurant.productos p set precio_barra_centimos = 850, precio_salon_centimos = 850, precio_terraza_centimos = 860, precio_centimos = 850
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cocteles' and p.nombre = 'Clover Club';
update restaurant.productos p set precio_barra_centimos = 850, precio_salon_centimos = 850, precio_terraza_centimos = 860, precio_centimos = 850
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cocteles' and p.nombre = 'Gin Fizz';
update restaurant.productos p set precio_barra_centimos = 900, precio_salon_centimos = 900, precio_terraza_centimos = 910, precio_centimos = 900
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cocteles' and p.nombre = 'Gin Berry';
update restaurant.productos p set precio_barra_centimos = 750, precio_salon_centimos = 750, precio_terraza_centimos = 760, precio_centimos = 750
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cocteles' and p.nombre = 'Bramble';
update restaurant.productos p set precio_barra_centimos = 950, precio_salon_centimos = 950, precio_terraza_centimos = 960, precio_centimos = 950
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cocteles' and p.nombre = 'Mezcal Mule';
update restaurant.productos p set precio_barra_centimos = 800, precio_salon_centimos = 800, precio_terraza_centimos = 810, precio_centimos = 800
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cocteles' and p.nombre = 'Margarita';
update restaurant.productos p set precio_barra_centimos = 850, precio_salon_centimos = 850, precio_terraza_centimos = 860, precio_centimos = 850
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cocteles' and p.nombre = 'Palomita';
update restaurant.productos p set precio_barra_centimos = 950, precio_salon_centimos = 950, precio_terraza_centimos = 960, precio_centimos = 950
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cocteles' and p.nombre = 'Palomita Mexicana';
update restaurant.productos p set precio_barra_centimos = 900, precio_salon_centimos = 900, precio_terraza_centimos = 910, precio_centimos = 900
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cocteles' and p.nombre = 'Pisco Sour';
update restaurant.productos p set precio_barra_centimos = 950, precio_salon_centimos = 950, precio_terraza_centimos = 960, precio_centimos = 950
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cocteles' and p.nombre = 'Chilcano';
update restaurant.productos p set precio_barra_centimos = 900, precio_salon_centimos = 800, precio_terraza_centimos = 810, precio_centimos = 800
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cocteles' and p.nombre = 'Whisky Sour';
update restaurant.productos p set precio_barra_centimos = 950, precio_salon_centimos = 950, precio_terraza_centimos = 960, precio_centimos = 950
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cocteles' and p.nombre = 'Holy Basil';
update restaurant.productos p set precio_barra_centimos = 950, precio_salon_centimos = 950, precio_terraza_centimos = 960, precio_centimos = 950
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cocteles' and p.nombre = 'Smoky Dark and Stormy';
update restaurant.productos p set precio_barra_centimos = 350, precio_salon_centimos = 350, precio_terraza_centimos = 360, precio_centimos = 350
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cocteles' and p.nombre = 'Vermut Preparado';
update restaurant.productos p set precio_barra_centimos = 690, precio_salon_centimos = 690, precio_terraza_centimos = 700, precio_centimos = 690
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cocteles' and p.nombre = 'Spritz';
update restaurant.productos p set precio_barra_centimos = 600, precio_salon_centimos = 600, precio_terraza_centimos = 610, precio_centimos = 600
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cocteles' and p.nombre = 'Spritz 0,0';
update restaurant.productos p set precio_barra_centimos = 690, precio_salon_centimos = 690, precio_terraza_centimos = 700, precio_centimos = 690
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cocteles' and p.nombre = 'Palomita Spritz';
update restaurant.productos p set precio_barra_centimos = 600, precio_salon_centimos = 600, precio_terraza_centimos = 610, precio_centimos = 600
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cocteles' and p.nombre = 'Negroni';
update restaurant.productos p set precio_barra_centimos = 850, precio_salon_centimos = 850, precio_terraza_centimos = 860, precio_centimos = 850
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cocteles' and p.nombre = 'Bloody Mary';
update restaurant.productos p set precio_barra_centimos = 500, precio_salon_centimos = 510, precio_terraza_centimos = 520, precio_centimos = 510
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cocteles' and p.nombre = '1/2 Bloody Mary';
update restaurant.productos p set precio_barra_centimos = 900, precio_salon_centimos = 900, precio_terraza_centimos = 910, precio_centimos = 900
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cocteles' and p.nombre = 'Caipirinha';
update restaurant.productos p set precio_barra_centimos = 900, precio_salon_centimos = 900, precio_terraza_centimos = 910, precio_centimos = 900
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cocteles' and p.nombre = 'Mai Tai';
update restaurant.productos p set precio_barra_centimos = 900, precio_salon_centimos = 900, precio_terraza_centimos = 910, precio_centimos = 900
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cocteles' and p.nombre = 'Long Island';
update restaurant.productos p set precio_barra_centimos = 700, precio_salon_centimos = 700, precio_terraza_centimos = 710, precio_centimos = 700
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cocteles' and p.nombre = 'Elan Tropical';
update restaurant.productos p set precio_barra_centimos = 700, precio_salon_centimos = 700, precio_terraza_centimos = 710, precio_centimos = 700
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cocteles' and p.nombre = 'Perla Roja';
update restaurant.productos p set precio_barra_centimos = 750, precio_salon_centimos = 750, precio_terraza_centimos = 760, precio_centimos = 750
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cocteles' and p.nombre = 'Mula Botánica';
update restaurant.productos p set precio_barra_centimos = 750, precio_salon_centimos = 750, precio_terraza_centimos = 760, precio_centimos = 750
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cocteles' and p.nombre = 'Apple Fizz';
update restaurant.productos p set precio_barra_centimos = 700, precio_salon_centimos = 700, precio_terraza_centimos = 710, precio_centimos = 700
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cocteles' and p.nombre = 'Virgin Mary';
update restaurant.productos p set precio_barra_centimos = 950, precio_salon_centimos = 950, precio_terraza_centimos = 960, precio_centimos = 950
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cocteles' and p.nombre = 'La Bella y la Bestia';
update restaurant.productos p set precio_barra_centimos = 900, precio_salon_centimos = 900, precio_terraza_centimos = 910, precio_centimos = 900
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cocteles' and p.nombre = 'Green Lander';
update restaurant.productos p set precio_barra_centimos = 850, precio_salon_centimos = 850, precio_terraza_centimos = 860, precio_centimos = 850
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Barceló';
update restaurant.productos p set precio_barra_centimos = 850, precio_salon_centimos = 850, precio_terraza_centimos = 860, precio_centimos = 850
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Santa Teresa';
update restaurant.productos p set precio_barra_centimos = 850, precio_salon_centimos = 850, precio_terraza_centimos = 860, precio_centimos = 850
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Habana 7';
update restaurant.productos p set precio_barra_centimos = 850, precio_salon_centimos = 850, precio_terraza_centimos = 860, precio_centimos = 850
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Santísima Trinidad';
update restaurant.productos p set precio_barra_centimos = 850, precio_salon_centimos = 850, precio_terraza_centimos = 860, precio_centimos = 850
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Kraken';
update restaurant.productos p set precio_barra_centimos = 850, precio_salon_centimos = 850, precio_terraza_centimos = 860, precio_centimos = 850
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Cuba Libre';
update restaurant.productos p set precio_barra_centimos = 850, precio_salon_centimos = 850, precio_terraza_centimos = 860, precio_centimos = 850
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'MG Paradiso';
update restaurant.productos p set precio_barra_centimos = 850, precio_salon_centimos = 850, precio_terraza_centimos = 860, precio_centimos = 850
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Seagrams';
update restaurant.productos p set precio_barra_centimos = 850, precio_salon_centimos = 850, precio_terraza_centimos = 860, precio_centimos = 850
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Beefeater';
update restaurant.productos p set precio_barra_centimos = 850, precio_salon_centimos = 850, precio_terraza_centimos = 860, precio_centimos = 850
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Tanqueray';
update restaurant.productos p set precio_barra_centimos = 900, precio_salon_centimos = 900, precio_terraza_centimos = 910, precio_centimos = 900
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Gin Le Tribute';
update restaurant.productos p set precio_barra_centimos = 950, precio_salon_centimos = 950, precio_terraza_centimos = 960, precio_centimos = 950
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Destornillador';
update restaurant.productos p set precio_barra_centimos = 950, precio_salon_centimos = 950, precio_terraza_centimos = 960, precio_centimos = 950
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Kendal';
update restaurant.productos p set precio_barra_centimos = 900, precio_salon_centimos = 850, precio_terraza_centimos = 860, precio_centimos = 850
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Nordés';
update restaurant.productos p set precio_barra_centimos = 850, precio_salon_centimos = 850, precio_terraza_centimos = 860, precio_centimos = 850
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Brockmans';
update restaurant.productos p set precio_barra_centimos = 900, precio_salon_centimos = 900, precio_terraza_centimos = 910, precio_centimos = 900
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Martin Miller''s';
update restaurant.productos p set precio_barra_centimos = 950, precio_salon_centimos = 950, precio_terraza_centimos = 960, precio_centimos = 950
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'G''Vine';
update restaurant.productos p set precio_barra_centimos = 850, precio_salon_centimos = 900, precio_terraza_centimos = 910, precio_centimos = 900
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Roku';
update restaurant.productos p set precio_barra_centimos = 950, precio_salon_centimos = 950, precio_terraza_centimos = 960, precio_centimos = 950
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Hendrick''s';
update restaurant.productos p set precio_barra_centimos = 950, precio_salon_centimos = 950, precio_terraza_centimos = 960, precio_centimos = 950
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Plymouth';
update restaurant.productos p set precio_barra_centimos = 950, precio_salon_centimos = 950, precio_terraza_centimos = 960, precio_centimos = 950
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Sipsmith';
update restaurant.productos p set precio_barra_centimos = 850, precio_salon_centimos = 850, precio_terraza_centimos = 860, precio_centimos = 850
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Bombay Sapphire';
update restaurant.productos p set precio_barra_centimos = 850, precio_salon_centimos = 850, precio_terraza_centimos = 860, precio_centimos = 850
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'MG Rosa';
update restaurant.productos p set precio_barra_centimos = 850, precio_salon_centimos = 850, precio_terraza_centimos = 860, precio_centimos = 850
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Brugal';
update restaurant.productos p set precio_barra_centimos = 1000, precio_salon_centimos = 1000, precio_terraza_centimos = 1010, precio_centimos = 1000
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Grey Goose';
update restaurant.productos p set precio_barra_centimos = 1000, precio_salon_centimos = 1000, precio_terraza_centimos = 1010, precio_centimos = 1000
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Haku';
update restaurant.productos p set precio_barra_centimos = 900, precio_salon_centimos = 900, precio_terraza_centimos = 910, precio_centimos = 900
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Ciroc';
update restaurant.productos p set precio_barra_centimos = 850, precio_salon_centimos = 850, precio_terraza_centimos = 860, precio_centimos = 850
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Red Label';
update restaurant.productos p set precio_barra_centimos = 900, precio_salon_centimos = 900, precio_terraza_centimos = 910, precio_centimos = 900
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Black Label';
update restaurant.productos p set precio_barra_centimos = 800, precio_salon_centimos = 800, precio_terraza_centimos = 810, precio_centimos = 800
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Jameson';
update restaurant.productos p set precio_barra_centimos = 1500, precio_salon_centimos = 1500, precio_terraza_centimos = 1510, precio_centimos = 1500
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Macallan';
update restaurant.productos p set precio_barra_centimos = 3000, precio_salon_centimos = 3000, precio_terraza_centimos = 3010, precio_centimos = 3000
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Macallan 15';
update restaurant.productos p set precio_barra_centimos = 6000, precio_salon_centimos = 6000, precio_terraza_centimos = 6010, precio_centimos = 6000
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Macallan 18';
update restaurant.productos p set precio_barra_centimos = 1000, precio_salon_centimos = 1000, precio_terraza_centimos = 1010, precio_centimos = 1000
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Zacapa';
update restaurant.productos p set precio_barra_centimos = 850, precio_salon_centimos = 850, precio_terraza_centimos = 860, precio_centimos = 850
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Licor 43';
update restaurant.productos p set precio_barra_centimos = 600, precio_salon_centimos = 600, precio_terraza_centimos = 610, precio_centimos = 600
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Toki';
update restaurant.productos p set precio_barra_centimos = 2300, precio_salon_centimos = 2300, precio_terraza_centimos = 2310, precio_centimos = 2300
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Yamazaki';
update restaurant.productos p set precio_barra_centimos = 1900, precio_salon_centimos = 1900, precio_terraza_centimos = 1910, precio_centimos = 1900
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Hibiki';
update restaurant.productos p set precio_barra_centimos = 1300, precio_salon_centimos = 1300, precio_terraza_centimos = 1310, precio_centimos = 1300
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Hakushu';
update restaurant.productos p set precio_barra_centimos = 900, precio_salon_centimos = 900, precio_terraza_centimos = 910, precio_centimos = 900
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Chita';
update restaurant.productos p set precio_barra_centimos = 850, precio_salon_centimos = 850, precio_terraza_centimos = 860, precio_centimos = 850
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Legendario';
update restaurant.productos p set precio_barra_centimos = 1000, precio_salon_centimos = 1000, precio_terraza_centimos = 1010, precio_centimos = 1000
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Glenfiddich 15';
update restaurant.productos p set precio_barra_centimos = 850, precio_salon_centimos = 860, precio_terraza_centimos = 870, precio_centimos = 860
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Jack Daniel''s';
update restaurant.productos p set precio_barra_centimos = 950, precio_salon_centimos = 950, precio_terraza_centimos = 960, precio_centimos = 950
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Santísima Trinidad 7';
update restaurant.productos p set precio_barra_centimos = 1500, precio_salon_centimos = 1500, precio_terraza_centimos = 1510, precio_centimos = 1500
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Monkey 47';
update restaurant.productos p set precio_barra_centimos = 850, precio_salon_centimos = 850, precio_terraza_centimos = 860, precio_centimos = 850
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Angelillo';
update restaurant.productos p set precio_barra_centimos = 850, precio_salon_centimos = 850, precio_terraza_centimos = 860, precio_centimos = 850
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Koi';
update restaurant.productos p set precio_barra_centimos = 700, precio_salon_centimos = 700, precio_terraza_centimos = 710, precio_centimos = 700
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'combinados' and p.nombre = 'Le Bombay';
update restaurant.productos p set precio_barra_centimos = 290, precio_salon_centimos = 290, precio_terraza_centimos = 300, precio_centimos = 290
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'refrescos' and p.nombre = 'Coca-Cola';
update restaurant.productos p set precio_barra_centimos = 290, precio_salon_centimos = 290, precio_terraza_centimos = 300, precio_centimos = 290
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'refrescos' and p.nombre = 'Coca-Cola Zero';
update restaurant.productos p set precio_barra_centimos = 290, precio_salon_centimos = 290, precio_terraza_centimos = 300, precio_centimos = 290
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'refrescos' and p.nombre = 'Bitter Kas';
update restaurant.productos p set precio_barra_centimos = 290, precio_salon_centimos = 290, precio_terraza_centimos = 300, precio_centimos = 290
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'refrescos' and p.nombre = 'Aquarius';
update restaurant.productos p set precio_barra_centimos = 290, precio_salon_centimos = 290, precio_terraza_centimos = 300, precio_centimos = 290
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'refrescos' and p.nombre = 'Nestea';
update restaurant.productos p set precio_barra_centimos = 290, precio_salon_centimos = 290, precio_terraza_centimos = 300, precio_centimos = 290
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'refrescos' and p.nombre = 'Bliss Naranja';
update restaurant.productos p set precio_barra_centimos = 160, precio_salon_centimos = 160, precio_terraza_centimos = 170, precio_centimos = 160
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'refrescos' and p.nombre = 'Agua';
update restaurant.productos p set precio_barra_centimos = 290, precio_salon_centimos = 290, precio_terraza_centimos = 300, precio_centimos = 290
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'refrescos' and p.nombre = 'Agua con Gas';
update restaurant.productos p set precio_barra_centimos = 290, precio_salon_centimos = 290, precio_terraza_centimos = 300, precio_centimos = 290
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'refrescos' and p.nombre = 'Kas Limón';
update restaurant.productos p set precio_barra_centimos = 340, precio_salon_centimos = 340, precio_terraza_centimos = 350, precio_centimos = 340
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'refrescos' and p.nombre = 'Zumo Piña';
update restaurant.productos p set precio_barra_centimos = 310, precio_salon_centimos = 310, precio_terraza_centimos = 320, precio_centimos = 310
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'refrescos' and p.nombre = 'Zumo Ace';
update restaurant.productos p set precio_barra_centimos = 310, precio_salon_centimos = 320, precio_terraza_centimos = 330, precio_centimos = 320
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'refrescos' and p.nombre = 'Zumo Melocotón';
update restaurant.productos p set precio_barra_centimos = 340, precio_salon_centimos = 340, precio_terraza_centimos = 350, precio_centimos = 340
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'refrescos' and p.nombre = 'Zumo Tomate';
update restaurant.productos p set precio_barra_centimos = 340, precio_salon_centimos = 340, precio_terraza_centimos = 350, precio_centimos = 340
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'refrescos' and p.nombre = 'Zumo Mango Maduro';
update restaurant.productos p set precio_barra_centimos = 340, precio_salon_centimos = 340, precio_terraza_centimos = 350, precio_centimos = 340
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'refrescos' and p.nombre = 'Zumo Manzana';
update restaurant.productos p set precio_barra_centimos = 290, precio_salon_centimos = 290, precio_terraza_centimos = 300, precio_centimos = 290
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'refrescos' and p.nombre = '7UP';
update restaurant.productos p set precio_barra_centimos = 170, precio_salon_centimos = 170, precio_terraza_centimos = 180, precio_centimos = 170
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'refrescos' and p.nombre = 'Mosto';
update restaurant.productos p set precio_barra_centimos = 480, precio_salon_centimos = 480, precio_terraza_centimos = 490, precio_centimos = 480
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'refrescos' and p.nombre = 'Kalimotxo';
update restaurant.productos p set precio_barra_centimos = 290, precio_salon_centimos = 290, precio_terraza_centimos = 300, precio_centimos = 290
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'refrescos' and p.nombre = 'Tónica';
update restaurant.productos p set precio_barra_centimos = 300, precio_salon_centimos = 300, precio_terraza_centimos = 310, precio_centimos = 300
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'refrescos' and p.nombre = 'Monster';
update restaurant.productos p set precio_barra_centimos = 250, precio_salon_centimos = 250, precio_terraza_centimos = 260, precio_centimos = 250
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'refrescos' and p.nombre = 'Agua Grande';
update restaurant.productos p set precio_barra_centimos = 230, precio_salon_centimos = 230, precio_terraza_centimos = 240, precio_centimos = 230
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'refrescos' and p.nombre = 'Mosto Grande';
update restaurant.productos p set precio_barra_centimos = 320, precio_salon_centimos = 320, precio_terraza_centimos = 330, precio_centimos = 320
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'refrescos' and p.nombre = 'Le Tribute';
update restaurant.productos p set precio_barra_centimos = 220, precio_salon_centimos = 220, precio_terraza_centimos = 230, precio_centimos = 220
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'vino' and p.nombre = 'Cueva Tinto';
update restaurant.productos p set precio_barra_centimos = 260, precio_salon_centimos = 260, precio_terraza_centimos = 270, precio_centimos = 260
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'vino' and p.nombre = 'Viuda Negra';
update restaurant.productos p set precio_barra_centimos = 360, precio_salon_centimos = 360, precio_terraza_centimos = 370, precio_centimos = 360
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'vino' and p.nombre = 'Viuda Negra Crianza';
update restaurant.productos p set precio_barra_centimos = 280, precio_salon_centimos = 280, precio_terraza_centimos = 290, precio_centimos = 280
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'vino' and p.nombre = 'Heras Cordón';
update restaurant.productos p set precio_barra_centimos = 260, precio_salon_centimos = 260, precio_terraza_centimos = 270, precio_centimos = 260
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'vino' and p.nombre = 'Tras las Cepas';
update restaurant.productos p set precio_barra_centimos = 280, precio_salon_centimos = 280, precio_terraza_centimos = 290, precio_centimos = 280
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'vino' and p.nombre = 'Hito';
update restaurant.productos p set precio_barra_centimos = 210, precio_salon_centimos = 210, precio_terraza_centimos = 220, precio_centimos = 210
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'vino' and p.nombre = 'Boyante';
update restaurant.productos p set precio_barra_centimos = 240, precio_salon_centimos = 240, precio_terraza_centimos = 250, precio_centimos = 240
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'vino' and p.nombre = 'Chardonnay';
update restaurant.productos p set precio_barra_centimos = 230, precio_salon_centimos = 230, precio_terraza_centimos = 240, precio_centimos = 230
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'vino' and p.nombre = 'Godello';
update restaurant.productos p set precio_barra_centimos = 260, precio_salon_centimos = 260, precio_terraza_centimos = 270, precio_centimos = 260
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'vino' and p.nombre = 'Albariño';
update restaurant.productos p set precio_barra_centimos = 210, precio_salon_centimos = 210, precio_terraza_centimos = 220, precio_centimos = 210
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'vino' and p.nombre = 'Txakoli Vizcaíno';
update restaurant.productos p set precio_barra_centimos = 280, precio_salon_centimos = 280, precio_terraza_centimos = 290, precio_centimos = 280
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'vino' and p.nombre = 'Txakoli Gipuzkoa';
update restaurant.productos p set precio_barra_centimos = 190, precio_salon_centimos = 200, precio_terraza_centimos = 210, precio_centimos = 200
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'vino' and p.nombre = 'Cueva Blanco';
update restaurant.productos p set precio_barra_centimos = 240, precio_salon_centimos = 240, precio_terraza_centimos = 250, precio_centimos = 240
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'vino' and p.nombre = 'Anahi';
update restaurant.productos p set precio_barra_centimos = 230, precio_salon_centimos = 230, precio_terraza_centimos = 240, precio_centimos = 230
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'vino' and p.nombre = 'Moscatel';
update restaurant.productos p set precio_barra_centimos = 450, precio_salon_centimos = 450, precio_terraza_centimos = 460, precio_centimos = 450
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'vino' and p.nombre = 'Cava';
update restaurant.productos p set precio_barra_centimos = 290, precio_salon_centimos = 290, precio_terraza_centimos = 300, precio_centimos = 290
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'vino' and p.nombre = 'Noc';
update restaurant.productos p set precio_barra_centimos = 240, precio_salon_centimos = 240, precio_terraza_centimos = 250, precio_centimos = 240
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'vermouth' and p.nombre = 'Vermut Rojo';
update restaurant.productos p set precio_barra_centimos = 250, precio_salon_centimos = 250, precio_terraza_centimos = 260, precio_centimos = 250
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'vermouth' and p.nombre = 'Vermut Blanco';
update restaurant.productos p set precio_barra_centimos = 50, precio_salon_centimos = 50, precio_terraza_centimos = 50, precio_centimos = 50
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'vermouth' and p.nombre = 'Suplemento Campari';
update restaurant.productos p set precio_barra_centimos = 290, precio_salon_centimos = 290, precio_terraza_centimos = 300, precio_centimos = 290
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cerveza' and p.nombre = 'Zurito Bodega';
update restaurant.productos p set precio_barra_centimos = 170, precio_salon_centimos = 170, precio_terraza_centimos = 180, precio_centimos = 170
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cerveza' and p.nombre = 'Zurito';
update restaurant.productos p set precio_barra_centimos = 560, precio_salon_centimos = 560, precio_terraza_centimos = 570, precio_centimos = 560
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cerveza' and p.nombre = 'Jarra';
update restaurant.productos p set precio_barra_centimos = 570, precio_salon_centimos = 570, precio_terraza_centimos = 580, precio_centimos = 570
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cerveza' and p.nombre = 'Pinta Rubia';
update restaurant.productos p set precio_barra_centimos = 300, precio_salon_centimos = 300, precio_terraza_centimos = 310, precio_centimos = 300
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cerveza' and p.nombre = 'Pinta Tostada';
update restaurant.productos p set precio_barra_centimos = 310, precio_salon_centimos = 310, precio_terraza_centimos = 320, precio_centimos = 310
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cerveza' and p.nombre = '1906';
update restaurant.productos p set precio_barra_centimos = 180, precio_salon_centimos = 180, precio_terraza_centimos = 190, precio_centimos = 180
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cerveza' and p.nombre = '1906 Red';
update restaurant.productos p set precio_barra_centimos = 170, precio_salon_centimos = 170, precio_terraza_centimos = 180, precio_centimos = 170
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cerveza' and p.nombre = 'Zurito Tostado';
update restaurant.productos p set precio_barra_centimos = 290, precio_salon_centimos = 290, precio_terraza_centimos = 300, precio_centimos = 290
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cerveza' and p.nombre = 'Radler';
update restaurant.productos p set precio_barra_centimos = 380, precio_salon_centimos = 380, precio_terraza_centimos = 390, precio_centimos = 380
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cerveza' and p.nombre = 'Jarra 1906';
update restaurant.productos p set precio_barra_centimos = 360, precio_salon_centimos = 360, precio_terraza_centimos = 370, precio_centimos = 360
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cerveza' and p.nombre = 'Jarra Radler';
update restaurant.productos p set precio_barra_centimos = 550, precio_salon_centimos = 550, precio_terraza_centimos = 560, precio_centimos = 550
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cerveza' and p.nombre = 'Pinta Radler';
update restaurant.productos p set precio_barra_centimos = 290, precio_salon_centimos = 290, precio_terraza_centimos = 300, precio_centimos = 290
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cerveza' and p.nombre = '1/3';
update restaurant.productos p set precio_barra_centimos = 320, precio_salon_centimos = 320, precio_terraza_centimos = 330, precio_centimos = 320
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cerveza' and p.nombre = 'Moretti';
update restaurant.productos p set precio_barra_centimos = 450, precio_salon_centimos = 450, precio_terraza_centimos = 460, precio_centimos = 450
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cerveza' and p.nombre = 'Paulaner';
update restaurant.productos p set precio_barra_centimos = 290, precio_salon_centimos = 290, precio_terraza_centimos = 300, precio_centimos = 290
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cerveza' and p.nombre = 'Mahou';
update restaurant.productos p set precio_barra_centimos = 0, precio_salon_centimos = 5, precio_terraza_centimos = 5, precio_centimos = 5
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cafes' and p.nombre = 'Suplemento Hielo';
update restaurant.productos p set precio_barra_centimos = 195, precio_salon_centimos = 195, precio_terraza_centimos = 205, precio_centimos = 195
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cafes' and p.nombre = 'Café con Leche';
update restaurant.productos p set precio_barra_centimos = 185, precio_salon_centimos = 185, precio_terraza_centimos = 195, precio_centimos = 185
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cafes' and p.nombre = 'Café Cortado';
update restaurant.productos p set precio_barra_centimos = 185, precio_salon_centimos = 185, precio_terraza_centimos = 195, precio_centimos = 185
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cafes' and p.nombre = 'Café Exprés';
update restaurant.productos p set precio_barra_centimos = 185, precio_salon_centimos = 185, precio_terraza_centimos = 195, precio_centimos = 185
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cafes' and p.nombre = 'Café Americano';
update restaurant.productos p set precio_barra_centimos = 220, precio_salon_centimos = 220, precio_terraza_centimos = 230, precio_centimos = 220
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cafes' and p.nombre = 'Café Capuccino';
update restaurant.productos p set precio_barra_centimos = 280, precio_salon_centimos = 280, precio_terraza_centimos = 290, precio_centimos = 280
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cafes' and p.nombre = 'Café Frappé';
update restaurant.productos p set precio_barra_centimos = 950, precio_salon_centimos = 950, precio_terraza_centimos = 960, precio_centimos = 950
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cafes' and p.nombre = 'Café Escocés';
update restaurant.productos p set precio_barra_centimos = 100, precio_salon_centimos = 100, precio_terraza_centimos = 110, precio_centimos = 100
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cafes' and p.nombre = 'Suplemento Baileys';
update restaurant.productos p set precio_barra_centimos = 200, precio_salon_centimos = 200, precio_terraza_centimos = 210, precio_centimos = 200
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cafes' and p.nombre = 'Infusión';
update restaurant.productos p set precio_barra_centimos = 300, precio_salon_centimos = 300, precio_terraza_centimos = 310, precio_centimos = 300
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cafes' and p.nombre = 'Zumo Desayuno';
update restaurant.productos p set precio_barra_centimos = 200, precio_salon_centimos = 210, precio_terraza_centimos = 220, precio_centimos = 210
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cafes' and p.nombre = 'Cola Cao';
update restaurant.productos p set precio_barra_centimos = 30, precio_salon_centimos = 30, precio_terraza_centimos = 30, precio_centimos = 30
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cafes' and p.nombre = 'Suplemento Vaso';
update restaurant.productos p set precio_barra_centimos = 380, precio_salon_centimos = 380, precio_terraza_centimos = 390, precio_centimos = 380
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'cafes' and p.nombre = 'Frappé';
update restaurant.productos p set precio_barra_centimos = 430, precio_salon_centimos = 430, precio_terraza_centimos = 440, precio_centimos = 430
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'orujos' and p.nombre = 'Baileys Copa';
update restaurant.productos p set precio_barra_centimos = 320, precio_salon_centimos = 320, precio_terraza_centimos = 330, precio_centimos = 320
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'orujos' and p.nombre = 'Baileys Txupito';
update restaurant.productos p set precio_barra_centimos = 400, precio_salon_centimos = 400, precio_terraza_centimos = 410, precio_centimos = 400
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'orujos' and p.nombre = 'Orujo Copa';
update restaurant.productos p set precio_barra_centimos = 300, precio_salon_centimos = 300, precio_terraza_centimos = 310, precio_centimos = 300
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'orujos' and p.nombre = 'Orujo Txupito';
update restaurant.productos p set precio_barra_centimos = 1200, precio_salon_centimos = 1200, precio_terraza_centimos = 1210, precio_centimos = 1200
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'orujos' and p.nombre = 'Puro (habano)';
update restaurant.productos p set precio_barra_centimos = 390, precio_salon_centimos = 390, precio_terraza_centimos = 400, precio_centimos = 390
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'picoteo' and p.nombre = 'Pulguita Jamón';
update restaurant.productos p set precio_barra_centimos = 390, precio_salon_centimos = 390, precio_terraza_centimos = 400, precio_centimos = 390
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'picoteo' and p.nombre = 'Pulguita Bonito';
update restaurant.productos p set precio_barra_centimos = 190, precio_salon_centimos = 190, precio_terraza_centimos = 200, precio_centimos = 190
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'picoteo' and p.nombre = 'Gilda Especial';
update restaurant.productos p set precio_barra_centimos = 850, precio_salon_centimos = 850, precio_terraza_centimos = 860, precio_centimos = 850
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'picoteo' and p.nombre = 'Piparras Fritas';
update restaurant.productos p set precio_barra_centimos = 750, precio_salon_centimos = 750, precio_terraza_centimos = 760, precio_centimos = 750
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'picoteo' and p.nombre = 'Rabas';
update restaurant.productos p set precio_barra_centimos = 240, precio_salon_centimos = 240, precio_terraza_centimos = 250, precio_centimos = 240
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'picoteo' and p.nombre = 'Aceitunas';
update restaurant.productos p set precio_barra_centimos = 160, precio_salon_centimos = 160, precio_terraza_centimos = 170, precio_centimos = 160
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'picoteo' and p.nombre = 'Patatas';
update restaurant.productos p set precio_barra_centimos = 950, precio_salon_centimos = 950, precio_terraza_centimos = 960, precio_centimos = 950
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'picoteo' and p.nombre = 'Croquetas (4 uds)';
update restaurant.productos p set precio_barra_centimos = 450, precio_salon_centimos = 450, precio_terraza_centimos = 460, precio_centimos = 450
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'picoteo' and p.nombre = 'Media Ración';
update restaurant.productos p set precio_barra_centimos = 700, precio_salon_centimos = 700, precio_terraza_centimos = 710, precio_centimos = 700
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'picoteo' and p.nombre = 'Media Tabla';
update restaurant.productos p set precio_barra_centimos = 390, precio_salon_centimos = 390, precio_terraza_centimos = 400, precio_centimos = 390
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'desayuno' and p.nombre = 'Croissant';
update restaurant.productos p set precio_barra_centimos = 2050, precio_salon_centimos = 2050, precio_terraza_centimos = 2060, precio_centimos = 2050
from restaurant.categorias c
where p.categoria_id = c.id and c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid and c.slug = 'desayuno' and p.nombre = 'Brunch';

-- 3. Para el resto de productos del proyecto (otros clientes / futuros
--    productos sin tarifa específica) las 3 columnas quedan NULL y la app
--    debe hacer fallback a precio_centimos.

-- 4. Comprobación: productos de Palomita Bar que siguen sin tarifas fijadas
select c.slug as categoria, p.nombre
from restaurant.productos p
join restaurant.categorias c on c.id = p.categoria_id
where c.cliente_id = 'e73669e4-7951-41f0-aa9a-16b391d0015c'::uuid
  and p.precio_barra_centimos is null
order by c.slug, p.orden;

commit;
