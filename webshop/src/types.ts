export interface Category {
  id: number;
  code: string;
  name: string;
}

export interface Product {
  id: number;
  sku: string;
  name: string;
  description: string;
  imageUrl: string;
  salePrice: number;
  contactForPrice?: boolean;
  stock: number;
  categoryId: number;
  unit: string;
  slug: string;
  specs?: string;
}

export interface CartItem {
  id: number;
  product_id: number;
  quantity: number;
  name?: string;
  sku?: string;
  unit_price?: number;
  amount?: number;
  imageUrl?: string;
}

export interface Cart {
  cart_id: string;
  items: CartItem[];
  subtotal: number;
  total: number;
  item_count: number;
}

export interface Customer {
  id: number;
  name: string;
  email: string;
  phone: string;
  customer_id?: number;
  picture?: string;
}

export interface OrderItem {
  id: number;
  product_id: number;
  name: string;
  sku: string;
  unit_price: number;
  quantity: number;
  amount: number;
}

export interface Order {
  id: number;
  code: string;
  customerId: number | null;
  customerName: string;
  customerPhone: string;
  customerEmail: string;
  shippingAddress: string;
  paymentMethod: string;
  note: string;
  items: OrderItem[];
  subtotal_amount: number;
  discount_amount: number;
  promo_code: string | null;
  promo_desc: string;
  total_amount: number;
  status: "new" | "pending" | "confirmed" | "processing" | "shipping" | "completed" | "cancelled" | "returned" | string;
  createdAt: string;
  erp_status?: string | null;
  erp_note?: string | null;
  return_status?: "none" | "requested" | "approved" | "rejected" | "completed" | string | null;
  return_requested_at?: string | null;
  return_processed_at?: string | null;
  return_note?: string | null;
  returned_at?: string | null;
  delivered_at?: string | null;
  completed_at?: string | null;
  tracking_number?: string | null;
  tracking_carrier?: string | null;
  logs?: OrderLog[];
}

export interface OrderLog {
  id: number;
  action: string;
  status_from?: string | null;
  status_to?: string | null;
  message?: string | null;
  meta?: string | null;
  created_by_name?: string | null;
  created_at?: string | null;
}

export interface Promotion {
  code: string;
  type: "percent" | "fixed";
  value: number;
  description: string;
}
