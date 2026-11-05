// Tipos compartidos — reflejan las tablas de supabase/migrations/0001_init.sql

export type PaymentMethod = "mercadopago" | "transfer" | "cash";
export type DeliveryMethod = "pickup" | "moto";
export type PaymentPlan = "full" | "deposit";
export type ProductKind = "simple" | "variants" | "lash_matrix";
export type ExpertiseLevel = "inicial" | "intermedio" | "avanzado" | "super_avanzado";

export type OrderStatus =
  | "pending_payment"
  | "awaiting_proof"
  | "deposit_paid"
  | "paid"
  | "preparing"
  | "ready_pickup"
  | "moto_coordinating"
  | "delivered"
  | "deposit_expired"
  | "cancelled";

export interface Category {
  id: number;
  parent_id: number | null;
  name: string;
  slug: string;
  sort_order: number;
}

export interface Brand {
  id: number;
  name: string;
  slug: string;
  featured: boolean;
}

export interface Variant {
  id: number;
  product_id: number;
  sku: string | null;
  option1: string | null;
  option2: string | null;
  option3: string | null;
  price_list: number;
  price_override: number | null;
  stock: number;
  track_stock: boolean;
  active: boolean;
  sort_order: number;
}

export interface AdhesiveSpecs {
  drying_min_s: number | null;
  drying_max_s: number | null;
  level: ExpertiseLevel | null;
  humidity_min: number | null;
  humidity_max: number | null;
  temp_min: number | null;
  temp_max: number | null;
  retention_weeks: string | null;
  viscosity: string | null;
  fumes: string | null;
  open_shelf_life: string | null;
}

export interface Product {
  id: number;
  name: string;
  slug: string;
  description: string | null;
  kind: ProductKind;
  option_names: string[];
  category_id: number | null;
  brand_id: number | null;
  featured: boolean;
  best_seller: boolean;
  brand?: Brand | null;
  category?: Category | null;
  variants: Variant[];
  images: { url: string; alt: string | null; sort_order: number }[];
  adhesive_specs?: AdhesiveSpecs | null;
}

export interface PaymentRule {
  method: PaymentMethod;
  label: string;
  discount_pct: number;
  excluded_category_ids: number[];
  allowed_delivery: DeliveryMethod[];
  allows_deposit: boolean;
  active: boolean;
}

export interface Settings {
  whatsapp: string;
  bank_alias: string | null;
  cbu: string | null;
  account_holder: string | null;
  announcement_text: string | null;
  store_hours: string | null;
  pickup_address: string | null;
  deposit_pct: number;
  deposit_business_days: number;
}

/** Línea del carrito tal como la guarda el navegador (solo ids y cantidades). */
export interface CartLine {
  variantId: number;
  qty: number;
}

/** Línea del carrito enriquecida con datos del catálogo, para mostrar. */
export interface CartLineView extends CartLine {
  productName: string;
  productSlug: string;
  optionsLabel: string;
  priceList: number;
  categoryId: number | null;
  image?: string;
  stock: number;
  trackStock: boolean;
}
