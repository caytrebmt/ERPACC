import React, { useState } from "react";
import { Outlet, useNavigate, useLocation } from "react-router-dom";
import {
  LayoutDashboard,
  FileText,
  Settings,
  LogOut,
  Menu,
  X,
  ChevronLeft,
  ChevronRight,
  Users,
  ShoppingCart,
  Package,
  BarChart3,
  UserCircle2,
} from "lucide-react";
import { useERPAuth } from "../contexts/ERPAuthContext";
import NotificationBell from "../components/erp/NotificationBell";

const SIDEBAR_KEY = "erp_sidebar_collapsed";

const menuItems = [
  { label: "Dashboard", to: "/erp/dashboard", icon: LayoutDashboard },
  { label: "Hóa đơn", to: "/erp/invoices", icon: FileText },
  { label: "Sản phẩm", to: "/erp/products", icon: Package },
  { label: "Khách hàng", to: "/erp/customers", icon: Users },
  { label: "KH Webshop", to: "/erp/shop-customers", icon: UserCircle2 },
  { label: "Báo cáo", to: "/erp/reports", icon: BarChart3 },
  { label: "Cài đặt", to: "/erp/settings", icon: Settings },
];

const ERPAppLayout: React.FC = () => {
  const [mobileOpen, setMobileOpen] = useState(false);
  const [collapsed, setCollapsed] = useState(
    () => localStorage.getItem(SIDEBAR_KEY) === "1"
  );
  const { user, logout } = useERPAuth();
  const navigate = useNavigate();
  const location = useLocation();

  const toggleCollapse = () => {
    setCollapsed((c) => {
      const next = !c;
      localStorage.setItem(SIDEBAR_KEY, next ? "1" : "0");
      return next;
    });
  };

  const handleLogout = () => {
    localStorage.removeItem("erp_access_token");
    localStorage.removeItem("erp_user");
    logout();
    navigate("/erp/login");
  };

  const isActive = (to: string) => location.pathname === to;

  const sidebarWidth = collapsed ? "w-16" : "w-64";

  return (
    <div className="flex h-screen bg-gray-50 dark:bg-gray-900">
      <aside
        className={`hidden lg:flex flex-col sticky top-0 h-screen bg-white dark:bg-gray-900 border-r border-gray-200 dark:border-gray-700 transition-[width] duration-200`}
      >
        <div className={`${sidebarWidth} flex flex-col h-full transition-[width] duration-200`}>
          <div className="flex items-center h-16 px-4 border-b border-gray-200 dark:border-gray-700">
            <div className="w-8 h-8 bg-indigo-600 rounded-lg flex items-center justify-center text-white font-bold text-sm">
              ERP
            </div>
            {!collapsed && (
              <span className="ml-3 font-bold text-gray-900 dark:text-white">
                ERP-VIET
              </span>
            )}
          </div>

          <nav className="flex-1 px-2 py-4 overflow-y-auto">
            <div className="flex flex-col gap-1">
              {menuItems.map((item) => {
                const Icon = item.icon;
                const active = isActive(item.to);
                return (
                  <button
                    key={item.to}
                    onClick={() => navigate(item.to)}
                    title={collapsed ? item.label : undefined}
                    className={`flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-all cursor-pointer w-full text-left ${
                      active
                        ? "bg-indigo-600 text-white shadow-xs"
                        : "text-gray-600 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-800 hover:text-indigo-600 dark:hover:text-indigo-400"
                    }`}
                  >
                    <Icon className="w-5 h-5 shrink-0" />
                    {!collapsed && <span className="truncate">{item.label}</span>}
                  </button>
                );
              })}
            </div>
          </nav>

          <div className="border-t border-gray-200 dark:border-gray-700 p-4">
            {!collapsed && user && (
              <div className="mb-3">
                <p className="text-sm font-semibold text-gray-800 dark:text-gray-200">
                  {user.name || user.email}
                </p>
                <p className="text-xs text-gray-500 dark:text-gray-400">
                  {user.email}
                </p>
              </div>
            )}
            <button
              onClick={handleLogout}
              className="flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium text-gray-600 dark:text-gray-400 hover:bg-red-50 dark:hover:bg-red-950/30 hover:text-red-600 dark:hover:text-red-400 transition-all cursor-pointer w-full"
            >
              <LogOut className="w-5 h-5 shrink-0" />
              {!collapsed && "Đăng xuất"}
            </button>
          </div>

          <div className="border-t border-gray-100 dark:border-gray-800 p-2 flex justify-center">
            <button
              onClick={toggleCollapse}
              className="p-2 rounded-lg text-gray-500 hover:bg-gray-100 dark:hover:bg-gray-800 hover:text-indigo-600 dark:hover:text-indigo-400 transition-colors cursor-pointer"
              title={collapsed ? "Mở rộng" : "Thu gọn"}
            >
              {collapsed ? (
                <ChevronRight className="w-5 h-5" />
              ) : (
                <ChevronLeft className="w-5 h-5" />
              )}
            </button>
          </div>
        </div>
      </aside>

      {mobileOpen && (
        <div className="lg:hidden fixed inset-0 z-50 flex">
          <div
            className="flex-1 bg-black/50"
            onClick={() => setMobileOpen(false)}
          />
          <div className="w-72 max-w-[80%] bg-white dark:bg-gray-900 h-full shadow-xl flex flex-col">
            <div className="flex items-center justify-between px-4 h-14 border-b border-gray-200 dark:border-gray-700">
              <span className="font-bold text-gray-900 dark:text-white">Menu</span>
              <button
                onClick={() => setMobileOpen(false)}
                className="p-2 text-gray-500 hover:text-gray-900 dark:hover:text-white cursor-pointer"
              >
                <X className="w-5 h-5" />
              </button>
            </div>
            <div className="flex-1 overflow-y-auto px-2 py-4">
              <div className="flex flex-col gap-1">
                {menuItems.map((item) => {
                  const Icon = item.icon;
                  const active = isActive(item.to);
                  return (
                    <button
                      key={item.to}
                      onClick={() => {
                        navigate(item.to);
                        setMobileOpen(false);
                      }}
                      className={`flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-all cursor-pointer w-full text-left ${
                        active
                          ? "bg-indigo-600 text-white"
                          : "text-gray-600 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-800"
                      }`}
                    >
                      <Icon className="w-5 h-5 shrink-0" />
                      <span>{item.label}</span>
                    </button>
                  );
                })}
              </div>
              <div className="mt-4 pt-4 border-t border-gray-200 dark:border-gray-700">
                <button
                  onClick={handleLogout}
                  className="flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium text-gray-600 dark:text-gray-400 hover:bg-red-50 dark:hover:bg-red-950/30 hover:text-red-600 cursor-pointer w-full"
                >
                  <LogOut className="w-5 h-5 shrink-0" />
                  Đăng xuất
                </button>
              </div>
            </div>
          </div>
        </div>
      )}

      <div className="flex-1 flex flex-col min-w-0">
        <header className="sticky top-0 z-30 h-14 bg-white dark:bg-gray-900 border-b border-gray-200 dark:border-gray-700 flex items-center justify-between px-4">
          <div className="flex items-center gap-3">
            <button
              onClick={() => setMobileOpen(true)}
              className="lg:hidden p-2 text-gray-500 hover:text-gray-900 dark:hover:text-white cursor-pointer"
            >
              <Menu className="w-5 h-5" />
            </button>
            <h1 className="text-lg font-semibold text-gray-900 dark:text-white">
              ERP-VIET
            </h1>
          </div>
          <div className="flex items-center gap-3">
            <NotificationBell />
            <span className="text-sm text-gray-500 dark:text-gray-400 hidden sm:block">
              {new Date().toLocaleDateString("vi-VN", {
                weekday: "long",
                year: "numeric",
                month: "long",
                day: "numeric",
              })}
            </span>
          </div>
        </header>

        <main className="flex-1 overflow-y-auto p-4 md:p-6">
          <Outlet />
        </main>
      </div>
    </div>
  );
};

export default ERPAppLayout;