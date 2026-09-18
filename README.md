# 🏗️ SeaShop — Infrastructure

Quản lý toàn bộ hạ tầng cho SeaShop: Database, Cache, Storage, Nginx.

## Kiến trúc

```
PRODUCTION:           LOCAL DEV:
─────────────────     ──────────────────────────
Supabase              Docker (seafood-infra/docker/)
 ├── PostgreSQL         ├── postgres:5432
 ├── Storage (S3)       ├── pgbouncer:6432
 └── Auth               └── redis:6379
```

## Cấu trúc

```
seafood-infra/
├── docker/
│   ├── docker-compose.infra.yml  ← Chỉ DB + Redis (dev thông thường)
│   ├── docker-compose.yml        ← Full stack test
│   └── .env.example
├── services/
│   ├── postgres/
│   │   ├── conf/postgresql.conf  ← Config PostgreSQL
│   │   └── init/                 ← SQL chạy khi tạo DB lần đầu
│   └── nginx/nginx.conf          ← Reverse proxy config
├── scripts/
│   └── setup.sh                  ← Script khởi tạo nhanh
└── .env.example                  ← Config Supabase (điền sau khi có project)
```

## Khởi động nhanh

```bash
# 1. Khởi động infra (Postgres + Redis) cho dev
docker compose up -d

# 2. Chạy Prisma migrate
cd ../seafood-api
npx prisma migrate dev

# 3. Khởi động API
npm run start:dev
```

## Test Full Stack với Docker

```bash
# Copy và điền config
cp seafood-infra/docker/.env.example seafood-infra/docker/.env

# Build và chạy toàn bộ stack
docker compose -f seafood-infra/docker/docker-compose.yml up --build

# Truy cập:
# Store:  http://localhost
# Admin:  http://localhost/admin
# API:    http://localhost/api/v1
# Health: http://localhost/health
```

## Production — Supabase Config

Sau khi tạo project trên Supabase, điền vào `seafood-api/.env`:

| Biến | Lấy từ đâu |
|------|-----------|
| `DATABASE_URL` | Settings → Database → Connect → **Transaction pooler** URI |
| `DATABASE_DIRECT_URL` | Settings → Database → Connect → **Direct connection** URI |
| `SUPABASE_URL` | Settings → API → Project URL |
| `SUPABASE_ANON_KEY` | Settings → API → anon/public key |
| `SUPABASE_SERVICE_KEY` | Settings → API → service_role key |

## Deploy

| Service | Platform | Command |
|---------|----------|---------|
| `seafood-api` | Render | Auto-deploy từ GitHub |
| `seafood-dashboard` | Vercel | Auto-deploy từ GitHub |
| `seafood-admin` | Vercel | Auto-deploy từ GitHub |
