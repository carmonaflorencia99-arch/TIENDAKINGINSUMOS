import type { Metadata } from "next";
import { getCategories, getPaymentRules, getSettings } from "@/lib/catalog";
import { CheckoutForm } from "./checkout-form";

export const metadata: Metadata = { title: "Finalizar compra", robots: { index: false } };
export const dynamic = "force-dynamic";

export default async function CheckoutPage() {
  const [rules, categories, settings] = await Promise.all([getPaymentRules(), getCategories(), getSettings()]);
  return (
    <CheckoutForm
      rules={rules.filter((r) => r.active)}
      categories={categories.map(({ id, parent_id }) => ({ id, parent_id }))}
      depositPct={settings.deposit_pct}
      depositDays={settings.deposit_business_days}
      pickupAddress={settings.pickup_address ?? ""}
      storeHours={settings.store_hours ?? ""}
    />
  );
}
