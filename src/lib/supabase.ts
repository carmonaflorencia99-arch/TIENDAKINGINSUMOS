import { createClient, type SupabaseClient } from "@supabase/supabase-js";

const url = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const anonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;

/** Cliente público: solo lee catálogo activo (lo limita RLS). */
export function publicClient(): SupabaseClient {
  return createClient(url, anonKey, { auth: { persistSession: false } });
}

/**
 * Cliente con service role: SOLO en el servidor (route handlers / server components).
 * Saltea RLS, por eso nunca se importa desde un componente "use client".
 */
export function adminClient(): SupabaseClient {
  const key = process.env.SUPABASE_SERVICE_ROLE_KEY;
  if (!key) throw new Error("Falta SUPABASE_SERVICE_ROLE_KEY");
  return createClient(url, key, { auth: { persistSession: false } });
}
