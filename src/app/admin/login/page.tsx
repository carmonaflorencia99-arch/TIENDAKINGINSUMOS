import type { Metadata } from "next";
import { signIn } from "./actions";

export const metadata: Metadata = { title: "Panel", robots: { index: false } };

type Props = { searchParams: Promise<{ error?: string }> };

const ERRORS: Record<string, string> = {
  credenciales: "El email o la contraseña no son correctos.",
  "sin-acceso": "Esta cuenta no tiene acceso al panel.",
};

export default async function LoginPage({ searchParams }: Props) {
  const { error } = await searchParams;
  return (
    <main className="grid min-h-dvh place-items-center bg-surface px-4">
      <form action={signIn} className="w-full max-w-sm space-y-4 border border-line bg-white p-8">
        {/* eslint-disable-next-line @next/next/no-img-element */}
        <img src="/brand/lockup-black.png" alt="King Insumos" width={880} height={300} className="mx-auto h-14 w-auto" />
        <h1 className="pt-2 text-center text-[18px]">Panel de administración</h1>
        {error && ERRORS[error] && (
          <p role="alert" className="bg-rose/10 p-3 text-sm font-medium text-rose">{ERRORS[error]}</p>
        )}
        <label className="block">
          <span className="eyebrow mb-1.5 block">Email</span>
          <input name="email" type="email" required autoComplete="username" className="field" />
        </label>
        <label className="block">
          <span className="eyebrow mb-1.5 block">Contraseña</span>
          <input name="password" type="password" required autoComplete="current-password" className="field" />
        </label>
        <button type="submit" className="btn w-full">Entrar</button>
      </form>
    </main>
  );
}
