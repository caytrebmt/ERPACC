FROM python:3.11-slim

WORKDIR /app

# Fix PDF + tiếng Việt
RUN apt-get update && apt-get install -y \
    libcairo2 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libgdk-pixbuf-2.0-0 \
    libffi-dev \
    libxml2 \
    libxslt1.1 \
    libjpeg62-turbo \
    zlib1g \
    libpng16-16 \
    shared-mime-info \
    fonts-dejavu \
    postgresql-client \
    curl \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

ENV PYTHONUNBUFFERED=1 \
    FLASK_ENV=production \
    APP_MODE=prod

# compile i18n
RUN if [ -d translations ]; then \
    pybabel compile -d translations || true; \
    fi

# Mặc định chạy theo kiểu production; compose dev sẽ override command.
CMD ["sh", "-c", "python wait_for_db.py && gunicorn -c gunicorn.conf.py --bind 0.0.0.0:$PORT wsgi:app"]
