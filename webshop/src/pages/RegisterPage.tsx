import React, { useState, useEffect } from "react";
import { Link, useNavigate } from "react-router-dom";
import { UserPlus, User, Mail, Phone, Lock, Loader2, ArrowLeft, Eye, EyeOff } from "lucide-react";
import { useAuth } from "../contexts/AuthContext";
import { useToast } from "../contexts/ToastContext";

const RegisterPage: React.FC = () => {
  const { register, isAuthenticated, loading } = useAuth();
  const { showToast } = useToast();
  const navigate = useNavigate();

  // Form states
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [phone, setPhone] = useState("");
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [submitting, setSubmitting] = useState(false);

  // New states: visibility toggles and confirm error
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);
  const [confirmError, setConfirmError] = useState("");

  useEffect(() => {
    if (isAuthenticated && !loading) {
      navigate("/", { replace: true });
    }
  }, [isAuthenticated, loading, navigate]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    const trimmedName = name.trim();
    const trimmedEmail = email.trim();
    const trimmedPhone = phone.trim();
    const pw = password.trim();
    const cpw = confirmPassword.trim();

    if (!trimmedName || !trimmedEmail || !trimmedPhone || !pw || !cpw) {
      showToast("Vui lòng điền đầy đủ tất cả các trường dữ liệu bắt buộc", "error");
      return;
    }

    if (pw.length < 8) {
      showToast("Mật khẩu bảo mật phải chứa ít nhất 8 ký tự", "error");
      return;
    }

    if (pw !== cpw) {
      setConfirmError("Xác nhận mật khẩu không khớp");
      showToast("Xác nhận mật khẩu bảo mật không khớp", "error");
      return;
    }

    try {
      setSubmitting(true);
      const result = await register({
        name: trimmedName,
        email: trimmedEmail,
        phone: trimmedPhone,
        password: pw,
        confirmPassword: cpw,
      });

      if (result.ok) {
        showToast(result.message, "success");
        navigate("/");
      } else {
        showToast(result.message, "error");
      }
    } catch (err) {
      showToast("Đăng ký tài khoản không thành công. Thử lại sau.", "error");
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <div className="max-w-md w-full mx-auto my-auto flex flex-col justify-center py-10 px-4 sm:px-6 lg:px-8">
      <div className="bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 rounded-2xl p-6 sm:p-8 shadow-xs flex flex-col gap-5 transition-colors duration-200">
        {/* Header Title */}
        <div className="text-center flex flex-col items-center gap-1">
          <span className="text-xl font-extrabold text-indigo-600 dark:text-indigo-400 flex items-center">
            WebShop <span className="text-indigo-850 dark:text-indigo-300 bg-indigo-50/70 dark:bg-indigo-950/40 border border-indigo-100 dark:border-indigo-900/40 px-2 py-0.5 rounded-md ml-1 text-xs font-semibold uppercase"></span>
          </span>
          <h2 className="text-xs font-bold text-gray-400 dark:text-gray-500 uppercase tracking-widest mt-1">Đăng ký tài khoản mới</h2>
        </div>

        {/* Register form */}
        <form onSubmit={handleSubmit} className="flex flex-col gap-3.5">
          <div className="flex flex-col gap-1">
            <label className="text-xs font-semibold text-gray-600 dark:text-gray-400 flex items-center gap-1.5">
              <User className="w-3.5 h-3.5 text-indigo-600 dark:text-indigo-450" /> Họ và tên <span className="text-red-500">*</span>
            </label>
            <input
              type="text"
              required
              placeholder="Ví dụ: Nguyễn Văn A"
              value={name}
              onChange={(e) => setName(e.target.value)}
              className="bg-gray-50 dark:bg-gray-850 border border-gray-200 dark:border-gray-700 rounded-lg px-3 py-2 text-xs focus:outline-none focus:ring-1 focus:ring-indigo-500 focus:bg-white dark:focus:bg-gray-800"
            />
          </div>

          <div className="flex flex-col gap-1">
            <label className="text-xs font-semibold text-gray-600 dark:text-gray-400 flex items-center gap-1.5">
              <Mail className="w-3.5 h-3.5 text-indigo-600 dark:text-indigo-450" /> Địa chỉ Email <span className="text-red-500">*</span>
            </label>
            <input
              type="email"
              required
              placeholder="customer@example.com"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="bg-gray-50 dark:bg-gray-850 border border-gray-200 dark:border-gray-700 rounded-lg px-3 py-2 text-xs focus:outline-none focus:ring-1 focus:ring-indigo-500 focus:bg-white dark:focus:bg-gray-800"
            />
          </div>

          <div className="flex flex-col gap-1">
            <label className="text-xs font-semibold text-gray-600 dark:text-gray-400 flex items-center gap-1.5">
              <Phone className="w-3.5 h-3.5 text-indigo-600 dark:text-indigo-450" /> Số điện thoại <span className="text-red-500">*</span>
            </label>
            <input
              type="tel"
              required
              placeholder="Ví dụ: 0909123456"
              value={phone}
              onChange={(e) => setPhone(e.target.value)}
              className="bg-gray-50 dark:bg-gray-850 border border-gray-200 dark:border-gray-700 rounded-lg px-3 py-2 text-xs focus:outline-none focus:ring-1 focus:ring-indigo-500 focus:bg-white dark:focus:bg-gray-800"
            />
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
            <div className="flex flex-col gap-1">
              <label className="text-xs font-semibold text-gray-600 dark:text-gray-400 flex items-center gap-1.5">
                <Lock className="w-3.5 h-3.5 text-indigo-600 dark:text-indigo-450" /> Mật khẩu <span className="text-red-500">*</span>
              </label>
              <div className="relative">
                <input
                  type={showPassword ? "text" : "password"}
                  required
                  placeholder="Tối thiểu 8 ký tự"
                  value={password}
                  onChange={(e) => {
                    setPassword(e.target.value);
                    // update confirm error live
                    if (confirmPassword && e.target.value.trim() !== confirmPassword.trim()) {
                      setConfirmError("Mật khẩu xác nhận không khớp");
                    } else {
                      setConfirmError("");
                    }
                  }}
                  className="w-full bg-gray-50 dark:bg-gray-850 border border-gray-200 dark:border-gray-700 rounded-lg px-3 py-2 text-xs focus:outline-none focus:ring-1 focus:ring-indigo-500 focus:bg-white dark:focus:bg-gray-800"
                />
                <button
                  type="button"
                  onClick={() => setShowPassword((s) => !s)}
                  className="absolute right-2 top-1/2 -translate-y-1/2 text-gray-500"
                  aria-label={showPassword ? "Hide password" : "Show password"}
                >
                  {showPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                </button>
              </div>
            </div>

            <div className="flex flex-col gap-1">
              <label className="text-xs font-semibold text-gray-600 dark:text-gray-400 flex items-center gap-1.5">
                <Lock className="w-3.5 h-3.5 text-indigo-600 dark:text-indigo-450" /> Xác nhận <span className="text-red-500">*</span>
              </label>
              <div className="relative">
                <input
                  type={showConfirmPassword ? "text" : "password"}
                  required
                  placeholder="Xác nhận mật khẩu"
                  value={confirmPassword}
                  onChange={(e) => {
                    const v = e.target.value;
                    setConfirmPassword(v);
                    setConfirmError(v.trim() !== password.trim() ? "Mật khẩu xác nhận không khớp" : "");
                  }}
                  className="w-full bg-gray-50 dark:bg-gray-850 border border-gray-200 dark:border-gray-700 rounded-lg px-3 py-2 text-xs focus:outline-none focus:ring-1 focus:ring-indigo-500 focus:bg-white dark:focus:bg-gray-800"
                />
                <button
                  type="button"
                  onClick={() => setShowConfirmPassword((s) => !s)}
                  className="absolute right-2 top-1/2 -translate-y-1/2 text-gray-500"
                  aria-label={showConfirmPassword ? "Hide confirm password" : "Show confirm password"}
                >
                  {showConfirmPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                </button>
              </div>
              {confirmError && <p className="text-xs text-red-500 mt-1">{confirmError}</p>}
            </div>
          </div>

          <button
            type="submit"
            disabled={submitting}
            className="w-full bg-indigo-600 text-white hover:bg-indigo-700 disabled:bg-gray-150 disabled:text-gray-400 font-bold rounded-xl py-3 text-xs flex items-center justify-center gap-2 transition-colors duration-150"
          >
            {submitting ? (
              <>
                <Loader2 className="w-4 h-4 animate-spin" />
                Đang khởi tạo...
              </>
            ) : (
              <>
                <UserPlus className="w-4 h-4" />
                Đăng ký tài khoản
              </>
            )}
          </button>
        </form>

        {/* Footer links */}
        <div className="border-t border-gray-100 dark:border-gray-800 pt-4 text-center">
          <p className="text-xs text-gray-500 dark:text-gray-400 m-0">
            Đã sẵn có tài khoản?{" "}
            <Link to="/login" className="font-bold text-indigo-600 dark:text-indigo-450 hover:underline inline-flex items-center gap-0.5">
              Đăng nhập <ArrowLeft className="w-3 h-3" />
            </Link>
          </p>
        </div>
      </div>
    </div>
  );
};

export default RegisterPage;
export {};
