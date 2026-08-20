# ERPACC - Project Documentation

## Overview

ERPACC is a Flask/SQLAlchemy ERP backend with a React/Vite webshop frontend.
The Flask application serves the ERP UI and APIs; the `webshop/` application is
an independently deployable customer-facing SPA that proxies `/api` requests
to Flask.

## Project structure

```text
app/                    Flask application
  core/                 App factory, extensions and bootstrap
  domains/              Domain models, routes and services
  routes/               ERP blueprint compatibility wrappers and APIs
  templates/            Legacy ERP and server-rendered shop templates
  static/               ERP assets and uploaded product images
config/                 Environment-based Flask configuration
migrations/             Alembic/Flask-Migrate revisions
webshop/                React customer webshop
  src/api/client.ts     Same-origin webshop API client
  src/contexts/         Customer, cart, theme and toast contexts
  src/layouts/          Customer-facing shop layout
  src/pages/             Catalog, checkout, account and order pages
  src/App.tsx            Webshop router
wsgi.py                 Production WSGI entry point (`wsgi:application`)
wait_for_db.py          DB readiness check and migration runner
```

## Development

```bash
# Backend
pip install -r requirements.txt
python run.py

# Frontend
cd webshop
npm ci
npm run dev
npm run lint
npm run build
```

The frontend must use relative `/api` URLs. Vite proxies those requests to the
Flask backend during development; the production Express server does the same
for the built SPA.

## Deployment

Production startup waits for PostgreSQL and runs the checked-in Alembic
revisions before starting Gunicorn:

```bash
python wait_for_db.py
gunicorn -c gunicorn.conf.py wsgi:application
```

Configure `SECRET_KEY`, `JWT_SECRET_KEY`, `DATABASE_URL` and
`SHOP_CORS_ORIGINS` in the deployment environment. Do not commit real secrets
or use a localhost database URL in production.
