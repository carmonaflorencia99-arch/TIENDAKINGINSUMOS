import type { Metadata } from "next";
import Link from "next/link";
import { requireAdmin } from "@/lib/admin";
import { signOut } from "../login/actions";
import { AdminNav } from "./nav";

export const metadata: Metadata = { title: { default: "Panel", template: "%s · Panel King" }, robots: { index: false } };
export const dynamic = "force-dynamic";

export default async function PanelLayout({ children }: { children: React.ReactNode }) {
  await requireAdmin();
  return (
    <div className="min-h-dvh bg-surface">
      <header className="sticky top-0 z-30 border-b border-line bg-white">
        <div className="mx-auto flex max-w-6xl items-center justify-between gap-4 px-4 py-3">
          <Link href="/admin" className="flex items-center gap-3">
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img src="/brand/mark-black.png" alt="" width={700} height={766} className="h-9 w-auto" />
            <span className="text-[12px] font-medium uppercase tracking-[2px]">Panel</span>
          </Link>
          <div className="flex items-center gap-4 text-[12px] uppercase tracking-[1.5px]">
            <Link href="/" target="_blank" className="hidden text-mute sm:inline">Ver tienda ↗</Link>
            <form action={signOut}>
              <button type="submit" className="uppercase tracking-[1.5px] text-mute">Salir</button>
            </form>
          </div>
        </div>
        <AdminNav />
      </header>
      <main className="mx-auto max-w-6xl px-4 py-6 pb-20">{children}</main>
    </div>
  );
}
