import React, { useState, useEffect, useMemo } from "react";
import { Plus, RefreshCw, Download } from "lucide-react";
import InvoiceTable from "../../components/erp/InvoiceTable";
import api from "../../services/api";

interface Invoice {
  id: number;
  code: string;
  customer_name: string;
  customer_tax_code: string;
  total_amount: number;
  vat_amount: number;
  status: string;
  invoice_date: string;
  due_date: string;
  created_at: string;
}

const statusColors: Record<string, string> = {
  draft: "bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-300",
  sent: "bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-400",
  paid: "bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400",
  overdue: "bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400",
  cancelled: "bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400",
  partial: "bg-yellow-100 text-yellow-800 dark:bg-yellow-900/30 dark:text-yellow-400",
};

const InvoicesPage: React.FC = () => {
  const [invoices, setInvoices] = useState<Invoice[]>([]);
  const [loading, setLoading] = useState(true);

  const columns = useMemo(
    () => [
      {
        accessorKey: "code",
        header: "Số HĐ",
        cell: (info: any) => (
          <span className="font-medium text-gray-900 dark:text-white">
            {info.getValue()}
          </span>
        ),
      },
      {
        accessorKey: "customer_name",
        header: "Khách hàng",
        cell: (info: any) => (
          <div>
            <div className="text-sm font-medium text-gray-900 dark:text-white">
              {info.getValue()}
            </div>
            <div className="text-xs text-gray-500 dark:text-gray-400">
              {info.row.original.customer_tax_code}
            </div>
          </div>
        ),
      },
      {
        accessorKey: "total_amount",
        header: "Tổng tiền",
        cell: (info: any) => (
          <span className="text-sm font-medium text-gray-900 dark:text-white">
            {Number(info.getValue()).toLocaleString("vi-VN")}đ
          </span>
        ),
      },
      {
        accessorKey: "vat_amount",
        header: "VAT",
        cell: (info: any) => (
          <span className="text-sm text-gray-600 dark:text-gray-400">
            {Number(info.getValue()).toLocaleString("vi-VN")}đ
          </span>
        ),
      },
      {
        accessorKey: "status",
        header: "Trạng thái",
        cell: (info: any) => {
          const status = info.getValue() as string;
          return (
            <span
              className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${
                statusColors[status] ||
                "bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-300"
              }`}
            >
              {status}
            </span>
          );
        },
      },
      {
        accessorKey: "invoice_date",
        header: "Ngày HĐ",
        cell: (info: any) => (
          <span className="text-sm text-gray-600 dark:text-gray-400">
            {new Date(info.getValue()).toLocaleDateString("vi-VN")}
          </span>
        ),
      },
      {
        accessorKey: "due_date",
        header: "Hạn thanh toán",
        cell: (info: any) => (
          <span className="text-sm text-gray-600 dark:text-gray-400">
            {new Date(info.getValue()).toLocaleDateString("vi-VN")}
          </span>
        ),
      },
    ],
    []
  );

  useEffect(() => {
    async function fetchInvoices() {
      try {
        setLoading(true);
        const res = await api.get("/invoices");
        if (res.data?.ok) {
          setInvoices(res.data.data || []);
        } else if (Array.isArray(res.data)) {
          setInvoices(res.data);
        }
      } catch (err) {
        console.error("Failed to fetch invoices", err);
        setInvoices([]);
      } finally {
        setLoading(false);
      }
    }
    fetchInvoices();
  }, []);

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-gray-900 dark:text-white">
            Hóa đơn
          </h1>
          <p className="text-sm text-gray-500 dark:text-gray-400 mt-1">
            Quản lý hóa đơn bán hàng
          </p>
        </div>
        <div className="flex items-center gap-3">
          <button className="flex items-center gap-2 px-4 py-2 text-sm font-medium text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-600 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors cursor-pointer">
            <Download className="w-4 h-4" />
            Xuất Excel
          </button>
          <button className="flex items-center gap-2 px-4 py-2 text-sm font-medium text-white bg-indigo-600 rounded-lg hover:bg-indigo-700 transition-colors cursor-pointer">
            <Plus className="w-4 h-4" />
            Tạo HĐ
          </button>
        </div>
      </div>

      {loading ? (
        <div className="flex items-center justify-center h-64">
          <div className="animate-spin rounded-full h-10 w-10 border-b-2 border-indigo-600" />
        </div>
      ) : (
        <InvoiceTable
          data={invoices}
          columns={columns}
          searchKey="code"
        />
      )}
    </div>
  );
};

export default InvoicesPage;