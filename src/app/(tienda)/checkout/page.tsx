import type { Metadata } from "next";
import { getCategories, getPaymentRules } from "@/lib/catalog";
import { CheckoutForm } from "./checkout-form";

export const metadata: Metadata = { title: "Finalizar pedido", robots: { index: false } };
export const dynamic = "force-dynamic";

export default async function CheckoutPage() {
  const [rules, categories] = await Promise.all([getPaymentRules(), getCategories()]);
  return (
    <CheckoutForm
      transferRule={rules.find((r) => r.method === "transfer")}
      categories={categories.map(({ id, parent_id }) => ({ id, parent_id }))}
    />
  );
}
