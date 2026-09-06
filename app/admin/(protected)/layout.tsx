import { redirect } from "next/navigation";
import { createSupabaseServerClient } from "@/lib/supabase/server";
import { AdminNav } from "@/components/admin/AdminNav";
import { getAdminRole } from "@/lib/auth/role";

// Todo lo que cuelga de /admin depende de la sesión del usuario (cookies,
// getUser()) y nunca debe servirse desde una página estática generada en
// build: no hay ninguna sesión real en ese momento. Sin esto, Next intenta
// prerenderizar estas páginas durante "next build" y falla — con o sin
// credenciales de Supabase reales, porque el problema de fondo es que
// intenta generar una página que depende de la sesión sin tener ninguna.
export const dynamic = "force-dynamic";

export default async function AdminLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const supabase = await createSupabaseServerClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    redirect("/admin/login");
  }

  const role = await getAdminRole(supabase);

  return (
    <div className="min-h-screen bg-noche-bg">
      <AdminNav role={role} />
      <div className="p-4 sm:p-6">{children}</div>
    </div>
  );
}
