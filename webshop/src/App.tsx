import React from "react";
import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";

// Providers Contexts
import { ToastProvider } from "./contexts/ToastContext";
import { AuthProvider } from "./contexts/AuthContext";
import { ERPAuthProvider } from "./contexts/ERPAuthContext";
import { CartProvider } from "./contexts/CartContext";
import { ThemeProvider } from "./contexts/ThemeProvider";
import { NotificationProvider } from "./contexts/NotificationContext";

// Components
import ProtectedRoute from "./components/ProtectedRoute";
import ShopLayout from "./layouts/ShopLayout";
import ERPAppLayout from "./layouts/ERPAppLayout";

// Pages
import CatalogPage from "./pages/CatalogPage";
import ProductPage from "./pages/ProductPage";
import CartPage from "./pages/CartPage";
import CheckoutPage from "./pages/CheckoutPage";
import OrderSuccessPage from "./pages/OrderSuccessPage";
import OrdersPage from "./pages/OrdersPage";
import OrderDetailPage from "./pages/OrderDetailPage";
import LoginPage from "./pages/LoginPage";
import RegisterPage from "./pages/RegisterPage";
import GoogleCallbackPage from "./pages/GoogleCallbackPage";
import AccountPage from "./pages/AccountPage";

// ERP Pages
import ERPLoginPage from "./pages/erp/LoginPage";
import DashboardPage from "./pages/erp/DashboardPage";
import InvoicesPage from "./pages/erp/InvoicesPage";
import ShopCustomersPage from "./pages/erp/ShopCustomersPage";

export default function App() {
  return (
    <ThemeProvider>
      <ToastProvider>
        <AuthProvider>
          <CartProvider>
            <BrowserRouter>
              <ShopLayout>
                <Routes>
                  {/* Public Catalog Routes */}
                  <Route path="/" element={<CatalogPage />} />
                  <Route path="/product/:slug" element={<ProductPage />} />
                  
                  {/* Public Cart & Checkout Flow */}
                  <Route path="/cart" element={<CartPage />} />
                  <Route path="/checkout" element={<CheckoutPage />} />
                  <Route path="/order-success/:code" element={<OrderSuccessPage />} />

                  {/* Authentication Routes */}
                  <Route path="/login" element={<LoginPage />} />
                  <Route path="/register" element={<RegisterPage />} />
                  <Route path="/auth/google/callback" element={<GoogleCallbackPage />} />

                  {/* Protected Customer Routes */}
                  <Route
                    path="/orders"
                    element={
                      <ProtectedRoute>
                        <OrdersPage />
                      </ProtectedRoute>
                    }
                  />
                  <Route
                    path="/orders/:code"
                    element={
                      <ProtectedRoute>
                        <OrderDetailPage />
                      </ProtectedRoute>
                    }
                  />
                  <Route
                    path="/account"
                    element={
                      <ProtectedRoute>
                        <AccountPage />
                      </ProtectedRoute>
                    }
                  />

                  {/* ERP Routes (with ERPAppLayout) */}
                  <Route element={<ERPAuthProvider><NotificationProvider><ERPAppLayout /></NotificationProvider></ERPAuthProvider>}>
                    <Route path="/erp/login" element={<ERPLoginPage />} />
                    <Route path="/erp/dashboard" element={<DashboardPage />} />
                    <Route path="/erp/invoices" element={<InvoicesPage />} />
                    <Route path="/erp/shop-customers" element={<ShopCustomersPage />} />
                    <Route path="/erp/*" element={<Navigate to="/erp/dashboard" replace />} />
                  </Route>

                  {/* Fallback Catch-All Route */}
                  <Route path="*" element={<Navigate to="/" replace />} />
                </Routes>
              </ShopLayout>
            </BrowserRouter>
          </CartProvider>
        </AuthProvider>
      </ToastProvider>
    </ThemeProvider>
  );
}
