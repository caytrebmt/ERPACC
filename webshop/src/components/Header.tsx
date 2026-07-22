import React, { useState, useEffect } from "react";
import { Link, useNavigate, useLocation, useSearchParams } from "react-router-dom";
import { ShoppingCart, Search, Sun, Moon } from "lucide-react";
import { useAuth } from "../contexts/AuthContext";
import { useCart } from "../contexts/CartContext";
import { useTheme } from "../contexts/ThemeContext";
import { motion, AnimatePresence } from "motion/react";

const Header: React.FC = () => {
  const { cart } = useCart();
  const { theme, toggleTheme } = useTheme();
  const navigate = useNavigate();
  const location = useLocation();
  const [searchParams] = useSearchParams();

  const [searchInput, setSearchInput] = useState("");

  // Sync search input from URL
  useEffect(() => {
    const query = searchParams.get("search");
    if (query) {
      setSearchInput(query);
    } else {
      setSearchInput("");
    }
  }, [searchParams]);

  const handleSearchSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (searchInput.trim()) {
      navigate(`/?search=${encodeURIComponent(searchInput.trim())}`);
    } else {
      navigate("/");
    }
  };

  const handleClearSearch = () => {
    setSearchInput("");
    navigate("/");
  };

  return (
    <header className="sticky top-0 z-40 bg-white dark:bg-gray-900 border-b border-gray-200 dark:border-gray-800 shadow-xs transition-colors duration-200">
      <div className="max-w-7xl mx-auto px-4 h-16 flex items-center justify-between gap-4">
        {/* Logo */}
        <Link to="/" className="flex items-center gap-2 shrink-0">
          <div className="w-8 h-8 bg-indigo-600 rounded-lg flex items-center justify-center">
            <span className="text-white font-bold text-lg leading-none">W</span>
          </div>
          <span className="text-xl font-bold tracking-tight text-[#111827] dark:text-white flex items-center">
            WebShop <span className="text-indigo-600 ml-1"></span>
          </span>
        </Link>

        {/* Search Bar - Desktop */}
        <form onSubmit={handleSearchSubmit} className="hidden md:flex items-center flex-1 max-w-md relative">
          <input
            type="text"
            placeholder="Tìm tên sản phẩm, mã SKU..."
            value={searchInput}
            onChange={(e) => setSearchInput(e.target.value)}
            className="w-full bg-gray-100 dark:bg-gray-800 border-none rounded-full pl-4 pr-10 py-1.5 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:bg-white dark:focus:bg-gray-950 text-gray-900 dark:text-gray-100 placeholder-gray-400 dark:placeholder-gray-500 transition-all"
          />
          <button type="submit" className="absolute right-3 text-gray-400 hover:text-indigo-600 dark:hover:text-indigo-400">
            <Search className="w-4 h-4" />
          </button>
        </form>

        {/* Right controls */}
        <div className="flex items-center gap-2 md:gap-3">
          {/* Theme Toggle Button - Desktop */}
          <button
            onClick={toggleTheme}
            className="hidden md:block p-2 text-gray-500 hover:text-gray-950 dark:text-gray-400 dark:hover:text-gray-100 rounded-full transition-colors cursor-pointer"
            title={theme === "dark" ? "Chuyển sang Giao diện Sáng" : "Chuyển sang Giao diện Tối"}
          >
            {theme === "dark" ? <Sun className="w-5 h-5 text-amber-500" /> : <Moon className="w-5 h-5" />}
          </button>

          {/* Cart Icon */}
          <Link to="/cart" className="relative p-2 text-gray-500 hover:text-gray-950 dark:text-gray-400 dark:hover:text-gray-100 transition-colors">
            <ShoppingCart className="w-6 h-6" />
            <AnimatePresence>
              {cart && cart.item_count > 0 && (
                <motion.span
                  initial={{ scale: 0 }}
                  animate={{ scale: 1 }}
                  exit={{ scale: 0 }}
                  className="absolute -top-1 -right-1 bg-indigo-600 text-white text-[10px] font-bold rounded-full w-5 h-5 flex items-center justify-center border border-white dark:border-gray-900"
                >
                  {cart.item_count}
                </motion.span>
              )}
            </AnimatePresence>
          </Link>

          {/* Mobile Theme Toggle */}
          <button
            onClick={toggleTheme}
            className="md:hidden p-2 text-gray-500 hover:text-gray-950 dark:text-gray-400 dark:hover:text-gray-100 rounded-full transition-colors cursor-pointer"
            title={theme === "dark" ? "Chuyển sang Giao diện Sáng" : "Chuyển sang Giao diện Tối"}
          >
            {theme === "dark" ? <Sun className="w-5 h-5 text-amber-500" /> : <Moon className="w-5 h-5" />}
          </button>
        </div>
      </div>

      {/* Search bar mobile */}
      <form onSubmit={handleSearchSubmit} className="md:hidden px-4 pb-3">
        <div className="relative">
          <input
            type="text"
            placeholder="Tìm kiếm sản phẩm..."
            value={searchInput}
            onChange={(e) => setSearchInput(e.target.value)}
            className="w-full bg-gray-50 dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-lg pl-4 pr-10 py-2 text-sm focus:outline-none text-gray-900 dark:text-gray-100 placeholder-gray-400 dark:placeholder-gray-500"
          />
          <button type="submit" className="absolute right-3 top-2.5 text-gray-400">
            <Search className="w-4 h-4" />
          </button>
        </div>
      </form>
    </header>
  );
};

export default Header;
export {};
