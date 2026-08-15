import React, { useState, useEffect } from "react";
import { Search, Plus, Eye, EyeOff, Edit, Trash2, X, Check, Shield, Mail, Phone, User as UserIcon, RefreshCw, Copy, CheckCircle2 } from "lucide-react";
import { shopCustomersApi } from "../../services/api";
import { useERPAuth } from "../../contexts/ERPAuthContext";

interface ShopCustomer {
  id: number;
  email: string;
  name: string;
  phone: string;
  role: string;
  is_active: boolean;
  customer_id: number | null;
  plain_password: string;
  created_at: string;
  last_login: string | null;
}

const ShopCustomersPage: React.FC = () => {
  const [items, setItems] = useState<ShopCustomer[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState("");
  const [page, setPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
  const [total, setTotal] = useState(0);
  const [modalOpen, setModalOpen] = useState(false);
  const [editing, setEditing] = useState<ShopCustomer | null>(null);
  const [saving, setSaving] = useState(false);
  const [showPassword, setShowPassword] = useState<Record<number, boolean>>({});
  const [form, setForm] = useState({ name: "", email: "", phone: "", password: "", is_active: true });
  const [resetResult, setResetResult] = useState<{ customer: ShopCustomer; newPassword: string } | null>(null);
  const [copied, setCopied] = useState(false);

  const fetchData = async () => {
    setLoading(true);
    try {
      const res = await shopCustomersApi.list({ search, page, per_page: 20 });
      if (res.data?.ok) {
        setItems(res.data.data?.items || []);
        setTotalPages(res.data.data?.pages || 1);
        setTotal(res.data.data?.total || 0);
      }
    } catch {
      setItems([]);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
  }, [page]);

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    setPage(1);
    fetchData();
  };

  const openCreate = () => {
    setEditing(null);
    setForm({ name: "", email: "", phone: "", password: "", is_active: true });
    setModalOpen(true);
  };

  const openEdit = (c: ShopCustomer) => {
    setEditing(c);
    setForm({ name: c.name, email: c.email, phone: c.phone || "", password: "", is_active: c.is_active });
    setModalOpen(true);
  };

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    setSaving(true);
    try {
      if (editing) {
        await shopCustomersApi.update(editing.id, form);
      } else {
        await shopCustomersApi.create(form);
      }
      setModalOpen(false);
      fetchData();
    } catch {
      // ignore
    } finally {
      setSaving(false);
    }
  };

  const handleToggle = async (id: number) => {
    await shopCustomersApi.toggle(id);
    fetchData();
  };

  const handleDelete = async (id: number) => {
    if (!confirm("Ban co chac muon xoa tai khoan khach hang nay?")) return;
    await shopCustomersApi.remove(id);
    fetchData();
  };

  const handleResetPassword = async (c: ShopCustomer) => {
    if (!confirm(`Reset mat khau cho ${c.name}? Mat khau moi se duoc tao ngau nhien.`)) return;
    try {
      const res = await shopCustomersApi.resetPassword(c.id);
      if (res.data?.ok) {
        setResetResult({ customer: c, newPassword: res.data.new_password || '' });
        fetchData();
      }
    } catch {
      alert('Reset mat khau that bai.');
    }
  };

  const toggleShowPassword = (id: number) => {
    setShowPassword((prev) => ({ ...prev, [id]: !prev[id] }));
  };

  const copyToClipboard = (text: string) => {
    navigator.clipboard.writeText(text).then(() => {
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    });
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-bold text-gray-900 dark:text-white">Quan ly khach hang webshop</h1>
        <button
          onClick={openCreate}
          className="inline-flex items-center gap-2 px-4 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition-colors cursor-pointer text-sm font-medium"
        >
          <Plus className="w-4 h-4" />
          Them moi
        </button>
      </div>

      <form onSubmit={handleSearch} className="flex items-center gap-3">
        <div className="relative flex-1 max-w-md">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 w-4 h-4" />
          <input
            type="text"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            placeholder="Tim kiem theo email, ten, so dien thoai..."
            className="w-full pl-10 pr-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white text-sm focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500"
          />
        </div>
        <button type="submit" className="px-4 py-2 bg-gray-100 dark:bg-gray-700 text-gray-700 dark:text-gray-300 rounded-lg hover:bg-gray-200 dark:hover:bg-gray-600 transition-colors cursor-pointer text-sm font-medium">
          Tim kiem
        </button>
      </form>

      <div className="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 shadow-sm overflow-hidden">
        <div className="overflow-x-auto">
          <table className="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
            <thead className="bg-gray-50 dark:bg-gray-700/50">
              <tr>
                <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase">ID</th>
                <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase">Ten</th>
                <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase">Email</th>
                <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase">Dien thoai</th>
                <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase">Mat khau</th>
                <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase">Trang thai</th>
                <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase">Ngay tao</th>
                <th className="px-4 py-3 text-right text-xs font-medium text-gray-500 dark:text-gray-400 uppercase">Thao tac</th>
              </tr>
            </thead>
            <tbody className="bg-white dark:bg-gray-800 divide-y divide-gray-200 dark:divide-gray-700">
              {loading ? (
                <tr>
                  <td colSpan={8} className="px-4 py-8 text-center text-gray-500 dark:text-gray-400">
                    Dang tai...
                  </td>
                </tr>
              ) : items.length === 0 ? (
                <tr>
                  <td colSpan={8} className="px-4 py-8 text-center text-gray-500 dark:text-gray-400">
                    Khong tim thay khach hang
                  </td>
                </tr>
              ) : (
                items.map((c) => (
                  <tr key={c.id} className="hover:bg-gray-50 dark:hover:bg-gray-700/50">
                    <td className="px-4 py-3 text-sm text-gray-900 dark:text-white">{c.id}</td>
                    <td className="px-4 py-3 text-sm text-gray-900 dark:text-white font-medium">{c.name}</td>
                    <td className="px-4 py-3 text-sm text-gray-500 dark:text-gray-400">{c.email}</td>
                    <td className="px-4 py-3 text-sm text-gray-500 dark:text-gray-400">{c.phone || "-"}</td>
                    <td className="px-4 py-3 text-sm">
                      <div className="flex items-center gap-2">
                        <span className="font-mono text-gray-600 dark:text-gray-300 bg-gray-100 dark:bg-gray-700 px-2 py-1 rounded flex-1 min-w-[120px]">
                          {c.plain_password ? (showPassword[c.id] ? c.plain_password : "******") : "-"}
                        </span>
                        {c.plain_password && (
                          <button
                            onClick={() => toggleShowPassword(c.id)}
                            className="p-1 text-gray-500 hover:text-indigo-600 dark:hover:text-indigo-400 cursor-pointer"
                            title={showPassword[c.id] ? "An mat khau" : "Hien mat khau"}
                          >
                            {showPassword[c.id] ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                          </button>
                        )}
                      </div>
                    </td>
                    <td className="px-4 py-3 text-sm">
                      <span className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${c.is_active ? "bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400" : "bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400"}`}>
                        {c.is_active ? "Hoat dong" : "Khoa"}
                      </span>
                    </td>
                    <td className="px-4 py-3 text-sm text-gray-500 dark:text-gray-400">
                      {new Date(c.created_at).toLocaleDateString("vi-VN")}
                    </td>
                    <td className="px-4 py-3 text-sm text-right">
                      <div className="flex items-center justify-end gap-1">
                        <button onClick={() => handleResetPassword(c)} className="p-1.5 text-gray-500 hover:text-indigo-600 dark:hover:text-indigo-400 cursor-pointer" title="Reset mat khau">
                          <RefreshCw className="w-4 h-4" />
                        </button>
                        <button onClick={() => openEdit(c)} className="p-1.5 text-gray-500 hover:text-indigo-600 dark:hover:text-indigo-400 cursor-pointer" title="Sua">
                          <Edit className="w-4 h-4" />
                        </button>
                        <button onClick={() => handleToggle(c.id)} className={`p-1.5 cursor-pointer ${c.is_active ? "text-yellow-500 hover:text-yellow-700" : "text-green-500 hover:text-green-700"}`} title={c.is_active ? "Khoa" : "Mo khoa"}>
                          <Shield className="w-4 h-4" />
                        </button>
                        <button onClick={() => handleDelete(c.id)} className="p-1.5 text-red-500 hover:text-red-700 cursor-pointer" title="Xoa">
                          <Trash2 className="w-4 h-4" />
                        </button>
                      </div>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>

        {totalPages > 1 && (
          <div className="flex items-center justify-between px-4 py-3 border-t border-gray-200 dark:border-gray-700">
            <span className="text-sm text-gray-500 dark:text-gray-400">
              Trang {page} / {totalPages} | Tong {total} ban ghi
            </span>
            <div className="flex items-center gap-1">
              <button onClick={() => setPage((p) => Math.max(1, p - 1))} disabled={page <= 1} className="px-3 py-1 text-sm border border-gray-300 dark:border-gray-600 rounded hover:bg-gray-50 dark:hover:bg-gray-700 disabled:opacity-50 cursor-pointer">
                Truoc
              </button>
              {Array.from({ length: Math.min(5, totalPages) }, (_, i) => {
                let p = page - 2;
                if (p < 1) p = 1;
                if (p + 4 > totalPages) p = Math.max(1, totalPages - 4);
                return p + i;
              }).filter((p) => p >= 1 && p <= totalPages).map((p) => (
                <button key={p} onClick={() => setPage(p)} className={`px-3 py-1 text-sm border rounded cursor-pointer ${p === page ? "bg-indigo-600 text-white border-indigo-600" : "border-gray-300 dark:border-gray-600 hover:bg-gray-50 dark:hover:bg-gray-700"}`}>
                  {p}
                </button>
              ))}
              <button onClick={() => setPage((p) => Math.min(totalPages, p + 1))} disabled={page >= totalPages} className="px-3 py-1 text-sm border border-gray-300 dark:border-gray-600 rounded hover:bg-gray-50 dark:hover:bg-gray-700 disabled:opacity-50 cursor-pointer">
                Sau
              </button>
            </div>
          </div>
        )}
      </div>

      {modalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50">
          <div className="bg-white dark:bg-gray-800 rounded-xl shadow-xl w-full max-w-lg mx-4 overflow-hidden">
            <div className="flex items-center justify-between px-6 py-4 border-b border-gray-200 dark:border-gray-700">
              <h2 className="text-lg font-semibold text-gray-900 dark:text-white">
                {editing ? "Chinh sua khach hang" : "Them khach hang moi"}
              </h2>
              <button onClick={() => setModalOpen(false)} className="p-1 text-gray-400 hover:text-gray-600 dark:hover:text-gray-300 cursor-pointer">
                <X className="w-5 h-5" />
              </button>
            </div>
            <form onSubmit={handleSave} className="p-6 space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Ten</label>
                <input required value={form.name} onChange={(e) => setForm({ ...form, name: e.target.value })} className="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white text-sm" />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Email</label>
                <input required type="email" value={form.email} onChange={(e) => setForm({ ...form, email: e.target.value })} className="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white text-sm" />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Dien thoai</label>
                <input value={form.phone} onChange={(e) => setForm({ ...form, phone: e.target.value })} className="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white text-sm" />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                  {editing ? "Mat khau moi (de trong neu khong doi)" : "Mat khau"}
                </label>
                <div className="relative">
                  <input
                    type="password"
                    required={!editing}
                    value={form.password}
                    onChange={(e) => setForm({ ...form, password: e.target.value })}
                    className="w-full px-3 py-2 pr-10 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white text-sm"
                  />
                </div>
              </div>
              <div className="flex items-center gap-2">
                <input id="is_active" type="checkbox" checked={form.is_active} onChange={(e) => setForm({ ...form, is_active: e.target.checked })} className="rounded border-gray-300 text-indigo-600 focus:ring-indigo-500" />
                <label htmlFor="is_active" className="text-sm text-gray-700 dark:text-gray-300">Hoat dong</label>
              </div>
              <div className="flex items-center justify-end gap-3 pt-2">
                <button type="button" onClick={() => setModalOpen(false)} className="px-4 py-2 text-sm text-gray-700 dark:text-gray-300 border border-gray-300 dark:border-gray-600 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-700 cursor-pointer">
                  Huy
                </button>
                <button type="submit" disabled={saving} className="px-4 py-2 text-sm text-white bg-indigo-600 rounded-lg hover:bg-indigo-700 disabled:opacity-50 cursor-pointer">
                  {saving ? "Dang luu..." : (editing ? "Cap nhat" : "Tao moi")}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {resetResult && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50">
          <div className="bg-white dark:bg-gray-800 rounded-xl shadow-xl w-full max-w-md mx-4 overflow-hidden">
            <div className="px-6 py-4 border-b border-gray-200 dark:border-gray-700 flex items-center gap-2">
              <CheckCircle2 className="w-5 h-5 text-green-600" />
              <h2 className="text-lg font-semibold text-gray-900 dark:text-white">Reset mat khau thanh cong</h2>
            </div>
            <div className="p-6 space-y-3">
              <p className="text-sm text-gray-600 dark:text-gray-300">
                Mat khau moi cho <strong>{resetResult.customer.name}</strong> ({resetResult.customer.email}):
              </p>
              <div className="flex items-center gap-2">
                <input
                  readOnly
                  value={resetResult.newPassword}
                  className="flex-1 px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-700 text-gray-900 dark:text-white text-sm font-mono"
                />
                <button
                  onClick={() => copyToClipboard(resetResult.newPassword)}
                  className="px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-700 cursor-pointer text-sm"
                  title="Copy mat khau"
                >
                  {copied ? <Check className="w-4 h-4 text-green-600" /> : <Copy className="w-4 h-4" />}
                </button>
              </div>
              <p className="text-xs text-gray-500 dark:text-gray-400">
                Vui long copy mat khau nay va gui cho khach hang qua email hoac tin nhan.
              </p>
            </div>
            <div className="px-6 py-4 border-t border-gray-200 dark:border-gray-700 flex justify-end">
              <button
                onClick={() => { setResetResult(null); setCopied(false); }}
                className="px-4 py-2 text-sm text-white bg-indigo-600 rounded-lg hover:bg-indigo-700 cursor-pointer"
              >
                Dong
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default ShopCustomersPage;
