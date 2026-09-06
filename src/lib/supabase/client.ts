import { createClient, type SupabaseClient } from "@supabase/supabase-js";

let cached: SupabaseClient | null = null;

function getClient(): SupabaseClient {
  if (cached) return cached;

  const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;

  if (!supabaseUrl || !supabaseAnonKey) {
    throw new Error(
      "Faltan NEXT_PUBLIC_SUPABASE_URL / NEXT_PUBLIC_SUPABASE_ANON_KEY. Revisa las variables de entorno del proyecto.",
    );
  }

  cached = createClient(supabaseUrl, supabaseAnonKey);
  return cached;
}

// Cliente único con la clave anon (pública, sujeta a RLS). No usar la
// service role aquí: eso queda para operaciones server-only futuras
// (webhook de Stripe, admin), fuera de este archivo.
//
// Construido perezosamente detrás de un Proxy en vez de al importar el
// módulo: si el cliente se construyera al importar, faltar las variables
// de entorno de Supabase (p. ej. en un build sin credenciales, o antes de
// configurarlas en un entorno nuevo) rompería la carga de cualquier página
// que arrastrara esa importación (p. ej. app/error.tsx, vía crearErrorLog),
// aunque nunca llegara a usar el cliente. Con el Proxy, el error solo
// salta si de verdad se invoca un método (p. ej. `supabase.rpc(...)`),
// momento en el que ya hay un `.catch()` en todas las llamadas.
export const supabase: SupabaseClient = new Proxy({} as SupabaseClient, {
  get(_target, prop, receiver) {
    return Reflect.get(getClient(), prop, receiver);
  },
});
