"use server";
import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { adminDb } from "@/lib/admin";
import { cancelOrder, completeDeposit, markPaid, registerDeposit, saveNotes, setStatus } from "@/lib/orders-admin";
import type { OrderStatus } from "@/lib/types";

/** Ejecuta la acción y vuelve al pedido con un mensaje (?ok= o ?error=). */
async function run(id: number, fn: () => Promise<string | void>) {
  let msg: string;
  try {
    msg = `ok=${encodeURIComponent((await fn()) || "Listo")}`;
  } catch (e) {
    msg = `error=${encodeURIComponent(e instanceof Error ? e.message : "No se pudo completar la acción.")}`;
  }
  revalidatePath("/admin", "layout");
  redirect(`/admin/pedidos/${id}?${msg}`);
}

const idOf = (f: FormData) => Number(f.get("id"));

export async function markPaidAction(f: FormData) {
  const id = idOf(f);
  const db = await adminDb();
  await run(id, async () => {
    await markPaid(db, id);
    return "Pago registrado. El stock quedó reservado.";
  });
}

export async function registerDepositAction(f: FormData) {
  const id = idOf(f);
  const db = await adminDb();
  await run(id, async () => {
    await registerDeposit(db, id);
    return "Seña registrada.";
  });
}

export async function completeDepositAction(f: FormData) {
  const id = idOf(f);
  const db = await adminDb();
  await run(id, async () => {
    const balance = await completeDeposit(db, id);
    return `Pago completado. Saldo cobrado con precios de hoy: $${balance.toLocaleString("es-AR")}.`;
  });
}

export async function setStatusAction(f: FormData) {
  const id = idOf(f);
  const db = await adminDb();
  await run(id, async () => {
    await setStatus(db, id, String(f.get("status")) as OrderStatus);
    return "Estado actualizado.";
  });
}

export async function cancelAction(f: FormData) {
  const id = idOf(f);
  const db = await adminDb();
  await run(id, async () => {
    await cancelOrder(db, id);
    return "Pedido cancelado. El stock volvió a estar disponible.";
  });
}

export async function notesAction(f: FormData) {
  const id = idOf(f);
  const db = await adminDb();
  await run(id, async () => {
    await saveNotes(db, id, String(f.get("notes") ?? ""));
    return "Notas guardadas.";
  });
}
