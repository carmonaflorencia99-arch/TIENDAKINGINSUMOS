"use server";
import { redirect } from "next/navigation";
import { sessionClient } from "@/lib/supabase-session";

export async function signIn(form: FormData) {
  const supabase = await sessionClient();
  const { error } = await supabase.auth.signInWithPassword({
    email: String(form.get("email") ?? "").trim(),
    password: String(form.get("password") ?? ""),
  });
  if (error) redirect("/admin/login?error=credenciales");
  redirect("/admin");
}

export async function signOut() {
  const supabase = await sessionClient();
  await supabase.auth.signOut();
  redirect("/admin/login");
}
