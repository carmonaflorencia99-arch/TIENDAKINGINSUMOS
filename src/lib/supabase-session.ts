/**
 * Cliente de Supabase con la sesión del navegador (cookies), para el panel.
 * Solo se usa en server components, server actions y route handlers.
 */
import { createServerClient } from "@supabase/ssr";
import { cookies } from "next/headers";

export async function sessionClient() {
  const store = await cookies();
  return createServerClient(process.env.NEXT_PUBLIC_SUPABASE_URL!, process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!, {
    cookies: {
      getAll: () => store.getAll(),
      setAll: (list) => {
        try {
          list.forEach(({ name, value, options }) => store.set(name, value, options));
        } catch {
          // en server components no se pueden escribir cookies; el middleware las renueva
        }
      },
    },
  });
}
