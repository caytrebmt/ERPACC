import express from "express";
import path from "path";
import http from "http";
import https from "https";
import cors from "cors";

const app = express();
const PORT = parseInt(process.env.PORT || '3000', 10);
const ERPACC_BACKEND = process.env.ERPACC_BACKEND_URL || "http://localhost:5000";

app.use(cors());

function setCorsHeaders(req: express.Request, res: express.Response) {
  const origin = req.headers.origin || "*";
  res.setHeader("Access-Control-Allow-Origin", origin);
  res.setHeader("Vary", "Origin");
  res.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
  res.setHeader(
    "Access-Control-Allow-Headers",
    "Content-Type, Authorization, X-Cart-Session-Id"
  );
  res.setHeader("Access-Control-Allow-Credentials", "true");
}

app.options("/api/shop/*", cors());
setCorsHeaders({} as express.Request, {} as express.Response);

function rewriteLocationHeader(
  headers: http.OutgoingHttpHeaders,
  req: express.Request
): http.OutgoingHttpHeaders {
  if (!headers || typeof headers !== "object") return headers;
  const location = headers.location;
  if (typeof location === "string" && location.startsWith(ERPACC_BACKEND)) {
    const relative = location.slice(ERPACC_BACKEND.length);
    headers.location = `${req.protocol}://${req.get("host")}${relative}`;
  }
  return headers;
}

function proxyToERP(req: express.Request, res: express.Response) {
  const url = new URL(req.originalUrl, ERPACC_BACKEND);
  const transport = url.protocol === "https:" ? https : http;

  const proxyReq = transport.request(
    {
      hostname: url.hostname,
      port: url.port,
      path: url.pathname + url.search,
      method: req.method,
      headers: {
        ...req.headers,
        host: url.host,
      },
    },
    (proxyRes) => {
      const body = [];
      proxyRes.on("data", (chunk) => body.push(chunk));
      proxyRes.on("end", () => {
        const buf = Buffer.concat(body);
        const headers = rewriteLocationHeader(
          { ...proxyRes.headers },
          req
        );
        setCorsHeaders(req, res);
        res.writeHead(proxyRes.statusCode || 500, headers);
        res.end(buf);
      });
    }
  );

  proxyReq.on("error", (err) => {
    console.error("Proxy error:", err);
    setCorsHeaders(req, res);
    res.status(502).json({
      ok: false,
      message: "Không thể kết nối với hệ thống máy chủ.",
    });
  });

  req.pipe(proxyReq);
}

app.use("/api/shop", (req, res) => {
  proxyToERP(req, res);
});

app.use("/static", (req, res) => {
  proxyToERP(req, res);
});

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
