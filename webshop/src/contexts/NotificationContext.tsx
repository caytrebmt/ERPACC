import React, { createContext, useContext, useState, useEffect, ReactNode } from "react";
import { notificationsApi } from "../services/api";

interface Notification {
  id: number;
  user_id: number;
  title: string;
  message: string;
  noti_type: string;
  module: string | null;
  reference_id: number | null;
  reference_type: string | null;
  is_read: boolean;
  created_at: string;
}

interface NotificationContextType {
  notifications: Notification[];
  unreadCount: number;
  loading: boolean;
  fetchNotifications: () => Promise<void>;
  fetchUnreadCount: () => Promise<void>;
  markRead: (id: number) => Promise<void>;
  markAllRead: () => Promise<void>;
}

const NotificationContext = createContext<NotificationContextType | undefined>(undefined);

export const NotificationProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
  const [notifications, setNotifications] = useState<Notification[]>([]);
  const [unreadCount, setUnreadCount] = useState(0);
  const [loading, setLoading] = useState(false);

  const fetchNotifications = async () => {
    setLoading(true);
    try {
      const res = await notificationsApi.list({ per_page: 20 });
      if (res.data?.ok) {
        setNotifications(res.data.data?.items || []);
      }
    } catch {
      setNotifications([]);
    } finally {
      setLoading(false);
    }
  };

  const fetchUnreadCount = async () => {
    try {
      const res = await notificationsApi.unreadCount();
      if (res.data?.ok) {
        setUnreadCount(res.data.data?.count || 0);
      }
    } catch {
      setUnreadCount(0);
    }
  };

  const markRead = async (id: number) => {
    try {
      await notificationsApi.markRead(id);
      setNotifications((prev) => prev.map((n) => (n.id === id ? { ...n, is_read: true } : n)));
      setUnreadCount((prev) => Math.max(0, prev - 1));
    } catch {
      // ignore
    }
  };

  const markAllRead = async () => {
    try {
      await notificationsApi.markAllRead();
      setNotifications((prev) => prev.map((n) => ({ ...n, is_read: true })));
      setUnreadCount(0);
    } catch {
      // ignore
    }
  };

  const addNotificationFromEvent = (event: any) => {
    const data = event?.data || {};
    const title = data.title || data.customer_name || 'Thông báo mới';
    const message = data.message || `Đơn hàng ${data.code || ''} vừa được tạo.`;
    const noti: Notification = {
      id: data.order_id || Date.now(),
      user_id: 0,
      title,
      message,
      noti_type: event?.type === 'order_cancelled' ? 'warning' : 'success',
      module: 'ecommerce',
      reference_id: data.order_id || null,
      reference_type: 'online_order',
      is_read: false,
      created_at: new Date().toISOString(),
    };
    setNotifications((prev) => [noti, ...prev].slice(0, 50));
    setUnreadCount((prev) => prev + 1);
  };

  useEffect(() => {
    fetchNotifications();
    fetchUnreadCount();

    const interval = setInterval(() => {
      fetchUnreadCount();
    }, 30000);

    let es: EventSource | null = null;
    try {
      es = new EventSource('/api/erp/events');
      es.onmessage = (evt) => {
        try {
          const parsed = JSON.parse(evt.data);
          if (parsed && parsed.type) {
            addNotificationFromEvent(parsed);
          }
        } catch {
          // ignore parse errors
        }
      };
      es.onerror = () => {
        if (es) {
          es.close();
          es = null;
        }
      };
    } catch {
      // SSE not supported, fallback to polling only
    }

    return () => {
      clearInterval(interval);
      if (es) {
        es.close();
      }
    };
  }, []);

  return (
    <NotificationContext.Provider
      value={{
        notifications,
        unreadCount,
        loading,
        fetchNotifications,
        fetchUnreadCount,
        markRead,
        markAllRead,
      }}
    >
      {children}
    </NotificationContext.Provider>
  );
};

export const useNotifications = () => {
  const context = useContext(NotificationContext);
  if (!context) {
    throw new Error("useNotifications must be used within a NotificationProvider");
  }
  return context;
};
