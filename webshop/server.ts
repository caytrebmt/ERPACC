import express from "express";
import path from "path";
import http from "http";

const app = express();
const PORT = parseInt(process.env.PORT || '3000', 10);
const ERPACC_BACKEND = process.env.ERPACC_BACKEND_URL || "http://localhost:5000";

// Simple proxy middleware for /api/shop/* -> ERPACC backend
function proxyToERP(req: express.Request, res: express.Response) {
  const url = new URL(req.originalUrl, ERPACC_BACKEND);
  
  const proxyReq = http.request({
    hostname: url.hostname,
    port: url.port,
    path: url.pathname + url.search,
    method: req.method,
    headers: {
      ...req.headers,
      host: url.host,
    },
  }, (proxyRes) => {
    const body = [];
    proxyRes.on("data", (chunk) => body.push(chunk));
    proxyRes.on("end", () => {
      const buf = Buffer.concat(body);
      res.writeHead(proxyRes.statusCode || 500, proxyRes.headers);
      res.end(buf);
    });
  });

  proxyReq.on("error", (err) => {
    console.error("Proxy error:", err);
    res.status(502).json({ ok: false, message: "Không thể kết nối với hệ thống máy chủ." });
  });

  req.pipe(proxyReq);
}

// Proxy API and static file requests to ERPACC backend
app.use("/api/shop", (req, res) => {
  proxyToERP(req, res);
});

app.use("/static", (req, res) => {
  proxyToERP(req, res);
});

// Vite Dev Server Middleware or Production Static Serving
async function startServer() {
  if (process.env.NODE_ENV !== "production") {
    const { createServer } = await import("vite");
    const vite = await createServer({
      server: { middlewareMode: true, port: 3000, host: true },
      appType: "spa",
    });
    app.use(vite.middlewares);
  } else {
    const distPath = path.join(process.cwd(), "dist");
    app.use(express.static(distPath));
    app.get("*", (req, res) => {
      res.sendFile(path.join(distPath, "index.html"));
    });
  }

  app.listen(PORT, "0.0.0.0", () => {
    console.log(`WebShop frontend listening on port ${PORT}`);
    console.log(`Proxying /api/shop/* -> ${ERPACC_BACKEND}/api/shop/*`);
  });
}

startServer();
