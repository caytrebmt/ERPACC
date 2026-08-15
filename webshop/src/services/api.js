import axios from "axios";

const API_BASE = "http://localhost:5000/api";

const client = axios.create({
  baseURL: API_BASE,
  headers: {
    "Content-Type": "application/json",
  },
  withCredentials: false,
});

client.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem("erp_access_token");
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

client.interceptors.response.use(
  (response) => {
    return response;
  },
  (error) => {
    if (error.response && error.response.status === 401) {
      localStorage.removeItem("erp_access_token");
      localStorage.removeItem("erp_user");
      window.dispatchEvent(new Event("erp_unauthorized"));
    }
    return Promise.reject(error);
  }
);

export default {
  get: (url, config) => client.get(url, config),
  post: (url, data, config) => client.post(url, data, config),
  put: (url, data, config) => client.put(url, data, config),
  delete: (url, config) => client.delete(url, config),
  patch: (url, data, config) => client.patch(url, data, config),
};

export const shopCustomersApi = {
  list: (params = {}) => client.get('/erp/shop-customers', { params }),
  get: (id) => client.get(`/erp/shop-customers/${id}`),
  create: (data) => client.post('/erp/shop-customers', data),
  update: (id, data) => client.put(`/erp/shop-customers/${id}`, data),
  remove: (id) => client.delete(`/erp/shop-customers/${id}`),
  toggle: (id) => client.put(`/erp/shop-customers/${id}/toggle`),
};

export const notificationsApi = {
  list: (params = {}) => client.get('/erp/notifications', { params }),
  unreadCount: () => client.get('/erp/notifications/unread-count'),
  markRead: (id) => client.put(`/erp/notifications/${id}/read`),
  markAllRead: () => client.put('/erp/notifications/read-all'),
  create: (data) => client.post('/erp/notifications', data),
};