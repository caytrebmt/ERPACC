import React, { useState, useEffect } from "react";
import { useParams, Link, useNavigate } from "react-router-dom";
import { ShoppingCart, ArrowLeft, Loader2, PackageOpen, ChevronRight, Tag } from "lucide-react";
import client from "../api/client";
import { Product } from "../types";
import { useCart } from "../contexts/CartContext";
import { useToast } from "../contexts/ToastContext";
import { formatPrice } from "../utils/format";
import { getProductImageSrc } from "../utils/images";
import ProductCard from "../components/ProductCard";

const ProductPage: React.FC = () => {
  const { slug } = useParams<{ slug: string }>();
  const navigate = useNavigate();
  const { addToCart } = useCart();
  const { showToast } = useToast();

  const [product, setProduct] = useState<Product | null>(null);
  const [categoryName, setCategoryName] = useState("");
  const [relatedProducts, setRelatedProducts] = useState<Product[]>([]);
  const [quantity, setQuantity] = useState(1);
  const [activeTab, setActiveTab] = useState<"desc" | "specs">("desc");
  const [loading, setLoading] = useState(false);
  const [adding, setAdding] = useState(false);
  const [imgSrc, setImgSrc] = useState<string | null>(null);

  useEffect(() => {
    async function loadProductData() {
      if (!slug) return;
      try {
        if (!product) setLoading(true);
        // Reset local states
        setQuantity(1);

        // Fetch current product details
        const prodRes = await client.get(`/api/shop/products/${slug}`);
        if (prodRes.data?.ok) {
          const prod: Product = prodRes.data.data;
          setProduct(prod);
          setImgSrc(getProductImageSrc(prod.imageUrl, prod.sku));

          // Get category name
          const catRes = await client.get("/api/shop/categories");
          if (catRes.data?.ok) {
            const cats = catRes.data.data.categories || [];
            const cat = cats.find((c: any) => c.id === prod.categoryId);
            if (cat) setCategoryName(cat.name);
          }

          // Load related products
          const relatedRes = await client.get("/api/shop/catalog", {
            params: { category_id: prod.categoryId, per_page: 4 },
          });
          if (relatedRes.data?.ok) {
            const filtered = relatedRes.data.data.products.filter((p: Product) => p.id !== prod.id);
            setRelatedProducts(filtered.slice(0, 3));
          }
        } else {
          showToast("Không thể tìm thấy thông tin sản phẩm này.", "error");
          navigate("/");
        }
      } catch (err) {
        console.error("Error loading product details", err);
        const message = err instanceof Error ? err.message : "Có lỗi xảy ra khi tải thông tin sản phẩm.";
        showToast(message, "error");
        navigate("/");
      } finally {
        setLoading(false);
      }
    }

    loadProductData();
  }, [slug]);

  const handleIncrement = () => {
    if (!product) return;
    if (quantity < product.stock) {
      setQuantity((prev) => prev + 1);
    } else {
      showToast(`Số lượng tồn kho tối đa khả dụng là ${product.stock} ${product.unit}`, "info");
    }
  };

  const handleDecrement = () => {
    if (quantity > 1) {
      setQuantity((prev) => prev - 1);
    }
  };

  const handleAddToCart = async () => {
    if (!product || product.stock <= 0) return;

    setAdding(true);
    const success = await addToCart(product.id, quantity);
    setAdding(false);

    if (success) {
      // Toast handles alert in CartContext
    }
  };

  if (loading && !product) {
    return (
      <div className="flex flex-col gap-6">
        <div className="bg-white dark:bg-gray-900 rounded-2xl border border-gray-200 dark:border-gray-800 overflow-hidden p-6 grid grid-cols-1 md:grid-cols-2 gap-8 shadow-xs animate-pulse">
          <div className="aspect-square bg-gray-100 dark:bg-gray-800 rounded-xl" />
          <div className="flex flex-col gap-4">
            <div className="h-4 w-1/4 bg-gray-100 dark:bg-gray-800 rounded-sm" />
            <div className="h-7 w-3/4 bg-gray-100 dark:bg-gray-800 rounded-sm" />
            <div className="h-16 w-full bg-gray-100 dark:bg-gray-800 rounded-xl" />
            <div className="h-12 w-full bg-gray-100 dark:bg-gray-800 rounded-xl mt-4" />
          </div>
        </div>
      </div>
    );
  }

  if (!product) {
    return (
      <div className="min-h-[50vh] flex flex-col items-center justify-center text-center p-4">
        <PackageOpen className="w-12 h-12 text-gray-300 dark:text-gray-700 mb-2" />
        <h3 className="font-semibold text-gray-700 dark:text-gray-300">Sản phẩm không khả dụng</h3>
        <Link to="/" className="text-xs font-semibold text-indigo-600 dark:text-indigo-400 hover:underline mt-2">
          Quay lại trang chủ
        </Link>
      </div>
    );
  }

  const isOutOfStock = product.stock <= 0;
  const showContact = product.contactForPrice || product.salePrice <= 0;

  return (
    <div className="flex flex-col gap-6">
      {/* Breadcrumb Navigation */}
      <nav className="flex items-center gap-1.5 text-xs text-gray-500 dark:text-gray-400 bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 rounded-lg px-4 py-2.5 transition-colors duration-200">
        <Link to="/" className="hover:text-indigo-600 dark:hover:text-indigo-400 transition-colors">
          Trang chủ
        </Link>
        <ChevronRight className="w-3 h-3" />
        <Link to={`/?category_id=${product.categoryId}`} className="hover:text-indigo-600 dark:hover:text-indigo-400 transition-colors">
          {categoryName || "Danh mục"}
        </Link>
        <ChevronRight className="w-3 h-3" />
        <span className="text-gray-800 dark:text-gray-200 font-medium truncate max-w-xs">{product.name}</span>
      </nav>

      {/* Product Primary Section */}
      <div className="bg-white dark:bg-gray-900 rounded-2xl border border-gray-200 dark:border-gray-800 overflow-hidden p-6 grid grid-cols-1 md:grid-cols-2 gap-8 shadow-xs transition-colors duration-200">
        {/* Gallery Image Box */}
        <div className="flex items-center justify-center">
          <div className="relative w-full max-w-sm aspect-square bg-gray-50 dark:bg-gray-950 rounded-xl overflow-hidden border border-gray-200 dark:border-gray-800">
            <img
              src={imgSrc || ''}
              alt={product.name}
              referrerPolicy="no-referrer"
              onError={() => setImgSrc(getProductImageSrc(null, product.sku))}
              className="w-full h-full object-contain p-4"
            />
          </div>
        </div>

        {/* Content Box */}
        <div className="flex flex-col">
        
          {/* SKU and Stock info 
          <div className="flex items-center gap-3 mb-2">
            <span className="text-[10px] bg-indigo-50 dark:bg-indigo-950/40 text-indigo-850 dark:text-indigo-300 font-semibold px-2 py-0.5 rounded-sm uppercase tracking-wider">
              SKU: {product.sku}
            </span>*/}
            {/*  {isOutOfStock ? (
              <span className="text-[10px] bg-red-100 dark:bg-red-950/40 text-red-800 dark:text-red-300 font-bold px-2 py-0.5 rounded-sm uppercase tracking-wider">
                Hết hàng
              </span>) : (
              <span className="text-[10px] bg-green-100 dark:bg-green-950/40 text-green-800 dark:text-green-300 font-semibold px-2 py-0.5 rounded-sm uppercase tracking-wider">
                Còn hàng
              </span>
            )}
          </div>
          */}
          <h1 className="text-xl md:text-2l font-bold text-gray-800 dark:text-white mb-3 tracking-tight leading-snug">
            {product.name}
          </h1>

          {/* Pricing area */}
          <div className="bg-indigo-50/50 dark:bg-indigo-950/20 p-4 rounded-xl border border-indigo-100/50 dark:border-indigo-900/40 my-2">
          
            {showContact ? (
              <div className="flex items-baseline gap-2">
                <span className="text-2xl font-black text-indigo-600 dark:text-indigo-400">
                  Liên hệ
                </span>
                <span className="text-xs text-gray-500 dark:text-gray-400">để biết giá chính xác</span>
              </div>
            ) : (
              <div className="flex items-baseline gap-2">
                <span className="text-xl font-black text-gray-900 dark:text-white">
                  {formatPrice(product.salePrice)}
                </span>
                <span className="text-xs text-gray-500 dark:text-gray-400">/ 1 {product.unit}</span>
              </div>
            )}
          </div>

          {/* Quantity picker & Add To Cart CTA */}
          <div className="mt-6 flex flex-col gap-4">
            {!isOutOfStock && !showContact && (
              <div className="flex items-center border border-gray-200 dark:border-gray-800 rounded-lg overflow-hidden bg-white dark:bg-gray-950">
                <button
                  onClick={handleDecrement}
                  disabled={quantity <= 1}
                  className="px-3.5 py-2"
                >
                  -
                </button>

                <input
                  type="number"
                  min={1}
                  max={product.stock}
                  value={quantity}
                  onChange={(e) => {
                    let value = Number(e.target.value);

                    if (isNaN(value)) value = 1;
                    if (value < 1) value = 1;
                    if (value > product.stock) value = product.stock;

                    setQuantity(value);
                  }}
                  className="w-12 text-center outline-none border-x border-gray-200 dark:border-gray-800 bg-transparent"
                />

                <button
                  onClick={handleIncrement}
                  disabled={quantity >= product.stock}
                  className="px-3.5 py-2"
                >
                  +
                </button>
              </div>
            )}

            <div className="flex gap-3 pt-2">
              <button
                onClick={handleAddToCart}
                disabled={isOutOfStock || showContact || adding}
                className="flex-1 bg-indigo-600 text-white hover:bg-indigo-700 disabled:bg-gray-150 disabled:text-gray-400 disabled:cursor-not-allowed font-bold rounded-xl py-3 px-6 text-sm flex items-center justify-center gap-2 transition-all shadow-xs cursor-pointer"
              >
                {adding ? (
                  <>
                    <Loader2 className="w-5 h-5 animate-spin" />
                    Đang thêm...
                  </>
                ) : (
                  <>
                    <ShoppingCart className="w-5 h-5" />
                    Thêm vào giỏ hàng
                  </>
                )}
              </button>
            </div>
          </div>

          {/* Quick specs short summary 
          <div className="mt-6 pt-6 border-t border-gray-100 dark:border-gray-800 text-xs text-gray-500 dark:text-gray-400 flex flex-col gap-2">
            <div className="flex justify-between py-1">
              <span className="font-medium text-gray-600 dark:text-gray-300">Đơn vị tính:</span>
              <span>{product.unit}</span>
            </div>
            <div className="flex justify-between py-1">
              <span className="font-medium text-gray-600 dark:text-gray-300">Mã SKU:</span>
              <span className="font-mono">{product.sku}</span>
            </div>
            <div className="flex justify-between py-1">
              <span className="font-medium text-gray-600 dark:text-gray-300">Kho hàng:</span>
              <span>{isOutOfStock ? "Tạm hết hàng" : (showContact ? "Liên hệ để đặt hàng" : `Sẵn sàng (${product.stock})`)}</span>
            </div>
          </div>
          */}
        </div>
      </div>

      {/* Tabs description / specifications */}
      <div className="bg-white dark:bg-gray-900 rounded-2xl border border-gray-200 dark:border-gray-800 p-6 shadow-xs transition-colors duration-200">
        {/* Tab Headers */}
        <div className="flex border-b border-gray-200 dark:border-gray-800 gap-4 mb-4">
          <button
            onClick={() => setActiveTab("desc")}
            className={`pb-3 font-semibold text-sm relative transition-all cursor-pointer ${activeTab === "desc" ? "text-indigo-600 dark:text-indigo-450" : "text-gray-400 hover:text-gray-600 dark:hover:text-gray-200"
              }`}
          >
            Mô tả sản phẩm
            {activeTab === "desc" && (
              <span className="absolute bottom-0 left-0 right-0 h-0.5 bg-indigo-600"></span>
            )}
          </button>
          {/*<button
            onClick={() => setActiveTab("specs")}
            className={`pb-3 font-semibold text-sm relative transition-all cursor-pointer ${activeTab === "specs" ? "text-indigo-600 dark:text-indigo-450" : "text-gray-400 hover:text-gray-600 dark:hover:text-gray-200"
              }`}
          >
            Thông số kỹ thuật
            {activeTab === "specs" && (
              <span className="absolute bottom-0 left-0 right-0 h-0.5 bg-indigo-600"></span>
            )}
          </button>*/}
        </div>

        {/* Tab Content */}
        <div className="text-sm leading-relaxed text-gray-600 dark:text-gray-300">
          {activeTab === "desc" ? (
            <p className="whitespace-pre-line">{product.description}</p>
          ) : (
            <div className="bg-gray-50/50 dark:bg-gray-950/50 border border-gray-200 dark:border-gray-800 rounded-xl p-4">
              {product.specs ? (
                <div className="grid grid-cols-1 gap-2.5">
                  {product.specs.split("|").map((spec, i) => {
                    const [key, val] = spec.split(":");
                    return (
                      <div key={i} className="flex justify-between items-center py-1.5 border-b border-gray-150/40 dark:border-gray-800/40 last:border-0 text-xs">
                        <span className="font-semibold text-gray-700 dark:text-gray-200">{key?.trim()}</span>
                        <span className="text-gray-500 dark:text-gray-400">{val?.trim()}</span>
                      </div>
                    );
                  })}
                </div>
              ) : (
                <p className="text-gray-400 dark:text-gray-500 text-xs text-center">Không có thông số kỹ thuật chi tiết.</p>
              )}
            </div>
          )}
        </div>
      </div>

      {/* Related Products Section */}
      {relatedProducts.length > 0 && (
        <div className="flex flex-col gap-4">
          <h2 className="text-xs font-bold text-gray-900 dark:text-white flex items-center gap-1.5 uppercase tracking-wider">
            <Tag className="w-4 h-4 text-indigo-600" />
            SẢN PHẨM LIÊN QUAN
          </h2>
          <div className="grid grid-cols-2 md:grid-cols-3 gap-4 md:gap-6">
            {relatedProducts.map((prod) => (
              <ProductCard key={prod.id} product={prod} />
            ))}
          </div>
        </div>
      )}
    </div>
  );
};

export default ProductPage;
export { };
