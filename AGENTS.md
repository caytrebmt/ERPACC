# ERPACC - Project Documentation

## Overview
ERPACC is a Flask-based ERP system with a React frontend (Vite + Tailwind CSS). The backend runs on Python/Flask port 5000, and the frontend runs on Vite dev server port 3000.

## Project Structure

```
D:\Soft\Project\ERPACC\
├── app/                    # Python Flask backend
│   ├── core/               # App factory, extensions (CORS, JWT, CSRF)
│   ├── domains/            # Domain modules (platform, sales, inventory, etc.)
│   ├── routes/             # Flask blueprints for ERP routes
│   ├── templates/          # Jinja2 HTML templates (legacy)
│   ├── static/             # Static assets (CSS, JS, fonts)
│   └── models/             # SQLAlchemy models
├── config/                 # Settings and configuration
├── webshop/                # React frontend (Vite + Tailwind + React Router)
│   ├── src/
│   │   ├── services/api.js       # ERP API service with JWT auto-interceptor
│   │   ├── contexts/
│   │   │   ├── AuthContext.tsx       # Shop customer auth
│   │   │   └── ERPAuthContext.tsx    # ERP admin auth (JWT from localStorage)
│   │   ├── layouts/
│   │   │   ├── ShopLayout.tsx        # Shop layout
│   │   │   └── ERPAppLayout.tsx      # ERP layout (Sidebar + Topbar)
│   │   ├── pages/
│   │   │   ├── erp/
│   │   │   │   ├── LoginPage.tsx
│   │   │   │   ├── DashboardPage.tsx
│   │   │   │   └── InvoicesPage.tsx
│   │   ├── components/
│   │   │   ├── erp/
│   │   │   │   └── InvoiceTable.tsx  # TanStack Table for invoices
│   │   │   └── ui/
│   │   │       ├── input.tsx         # Reusable Input component
│   │   │       └── button.tsx        # Reusable Button component
│   │   ├── api/
│   │   │   └── client.ts             # Shop API client (separate from ERP)
│   │   └── App.tsx                   # Main router (shop + ERP routes)
│   ├── vite.config.ts          # Vite config with API proxy
│   └── package.json
├── wsgi.py                   # WSGI entry point
└── config/settings.py        # App configuration
```

## Key Features

### ERP API Service (`src/services/api.js`)
- Axios-based HTTP client pointing to `http://localhost:5000/api`
- Auto-attaches JWT from `localStorage.getItem("erp_access_token")` to all requests
- Auto-handles 401 responses by clearing auth and dispatching `erp_unauthorized` event

### ERP Layout (`src/layouts/ERPAppLayout.tsx`)
- Sidebar with collapsible navigation (Dashboard, Invoices, Products, Customers, Reports, Settings)
- Topbar with date display and mobile menu toggle
- Collapsible on desktop (localStorage persistence)
- Mobile drawer for small screens

### ERP Authentication (`src/contexts/ERPAuthContext.tsx`)
- Reads JWT and user data from localStorage
- Auto-restores session on page reload
- Handles unauthorized logout events

### TanStack Table (`src/components/erp/InvoiceTable.tsx`)
- Full-text search filter
- Column sorting (click headers)
- Pagination with page navigation
- Responsive design

### React Router (ERP routes)
- `/erp/login` - Login page
- `/erp/dashboard` - Dashboard with stats
- `/erp/invoices` - Invoice list with TanStack Table

### CORS Configuration (Python Backend)
- `ERP_CORS_ORIGINS` in `config/settings.py` (default: `http://localhost:3000,http://localhost:5000`)
- CORS registered for `/api/*` routes in `app/core/__init__.py`
- Flask-CORS extension added to `app/core/extensions.py`

## Development

### Frontend (React)
```bash
cd webshop
npm run dev          # Start Vite dev server on port 3000
npm run build        # Build for production
npm run lint         # TypeScript check
```

### Backend (Flask)
```bash
# Install dependencies
pip install flask flask-cors flask-jwt-extended flask-login flask-sqlalchemy flask-migrate flask-wtf flask-caching flask-babel python-dotenv waitress

# Run development server
python wsgi.py
```

## Configuration

### Environment Variables (`.env`)
```env
SECRET_KEY=your-secret-key
DATABASE_URL=postgresql://postgres:password@localhost:5432/erpmini
SHOP_CORS_ORIGINS=http://localhost:3000
ERP_CORS_ORIGINS=http://localhost:3000,http://localhost:5000
```