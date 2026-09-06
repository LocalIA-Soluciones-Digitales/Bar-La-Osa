import { createServerClient } from "@supabase/ssr";
import { cookies } from "next/headers";

// Cliente server-side consciente de la sesión (cookies), para /admin.
// Sigue usando la clave anon: la autenticación viene de la cookie de
// sesión del usuario, y RLS decide qué puede ver/editar cada uno.
//
// La comprobación de variables de entorno vive DENTRO de la función a
// propósito, no a nivel de módulo: Next.js importa cada route handler
// (incluidos los de /api) durante "Collecting page data" en el build, y un
// throw a nivel de módulo rompía el build entero en Vercel aunque esa ruta
// nunca llegara a ejecutarse en producción sin credenciales reales. Con el
// throw dentro de la función, el build solo importa el módulo; el error
// (si procede) sale al llamar de verdad, en tiempo de petición.
export async function createSupabaseServerClient() {
  const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;

  if (!supabaseUrl || !supabaseAnonKey) {
    throw new Error(
      "Faltan NEXT_PUBLIC_SUPABASE_URL / NEXT_PUBLIC_SUPABASE_ANON_KEY. Revisa las variables de entorno del proyecto.",
    );
  }

  const cookieStore = await cookies();

  return createServerClient(supabaseUrl, supabaseAnonKey, {
    cookies: {
      getAll() {
        return cookieStore.getAll();
      },
      setAll(cookiesToSet) {
        try {
          cookiesToSet.forEach(({ name, value, options }) => {
            cookieStore.set(name, value, options);
          });
        } catch {
          // Se puede llamar desde un Server Component sin permiso de
          // escritura; el middleware se encarga de refrescar la sesión.
        }
      },
    },
  });
}
