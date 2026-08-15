import React, { createContext, useContext, useState, useEffect, ReactNode } from "react";
import api from "../services/api";

interface ERPUser {
  id: number;
  name: string;
  email: string;
  role: string;
}

interface ERPAuthContextType {
  user: ERPUser | null;
  loading: boolean;
  isAuthenticated: boolean;
  login: (email: string, password: string) => Promise<{ ok: boolean; message: string }>;
  logout: () => void;
}

const ERPAuthContext = createContext<ERPAuthContextType | undefined>(undefined);

export const ERPAuthProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
  const [user, setUser] = useState<ERPUser | null>(null);
  const [loading, setLoading] = useState<boolean>(true);

  useEffect(() => {
    const token = localStorage.getItem("erp_access_token");
    const userStr = localStorage.getItem("erp_user");
    if (token && userStr) {
      try {
        setUser(JSON.parse(userStr));
      } catch {
        localStorage.removeItem("erp_access_token");
        localStorage.removeItem("erp_user");
      }
    }
    setLoading(false);
  }, []);

  useEffect(() => {
    const handleUnauthorized = () => {
      setUser(null);
      localStorage.removeItem("erp_access_token");
      localStorage.removeItem("erp_user");
    };
    window.addEventListener("erp_unauthorized", handleUnauthorized);
    return () => {
      window.removeEventListener("erp_unauthorized", handleUnauthorized);
    };
  }, []);

  const login = async (email: string, password: string) => {
    try {
      const res = await api.post("/auth/login", { email, password });
      if (res.data && res.data.ok) {
        localStorage.setItem("erp_access_token", res.data.data.access_token);
        localStorage.setItem("erp_user", JSON.stringify(res.data.data.user));
        setUser(res.data.data.user);
        return { ok: true, message: res.data.message || "Đăng nhập thành công" };
      }
      return { ok: false, message: res.data.message || "Đăng nhập thất bại" };
    } catch (error: any) {
      const msg = error.response?.data?.message || "Lỗi mạng";
      return { ok: false, message: msg };
    }
  };

  const logout = () => {
    localStorage.removeItem("erp_access_token");
    localStorage.removeItem("erp_user");
    setUser(null);
  };

  return (
    <ERPAuthContext.Provider
      value={{
        user,
        loading,
        isAuthenticated: !!user,
        login,
        logout,
      }}
    >
      {children}
    </ERPAuthContext.Provider>
  );
};

export const useERPAuth = () => {
  const context = useContext(ERPAuthContext);
  if (!context) {
    throw new Error("useERPAuth must be used within an ERPAuthProvider");
  }
  return context;
};