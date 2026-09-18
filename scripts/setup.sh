#!/bin/bash
# ============================================
# SeaShop — Dev Environment Setup
# ============================================
set -e

echo "🦞 SeaShop — Setting up local development environment..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INFRA_DIR="$(dirname "$SCRIPT_DIR")"
DOCKER_DIR="$INFRA_DIR/docker"

# Copy .env if not exists
if [ ! -f "$DOCKER_DIR/.env" ]; then
    cp "$DOCKER_DIR/.env.example" "$DOCKER_DIR/.env"
    echo "✅ Created docker/.env from .env.example"
    echo "⚠️  Hãy kiểm tra và cập nhật seafood-infra/docker/.env trước khi chạy!"
else
    echo "ℹ️  docker/.env đã tồn tại, bỏ qua"
fi

# Function to check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        echo "❌ Docker chưa chạy. Hãy khởi động Docker Desktop trước."
        exit 1
    fi
}

check_docker

echo ""
echo "Chọn chế độ khởi động:"
echo "  1) Chỉ infra (Postgres + PgBouncer + Redis) — dùng khi dev bình thường"
echo "  2) Full stack (infra + API + Dashboard + Admin + Nginx) — dùng khi test Docker build"
echo ""
read -p "Nhập lựa chọn (1/2): " choice

case "$choice" in
  1)
    echo "🚀 Khởi động Infra services..."
    docker compose -f "$DOCKER_DIR/../docker/docker-compose.infra.yml" up -d
    echo ""
    echo "✅ Infra đã sẵn sàng!"
    echo ""
    echo "📋 Connection Details:"
    echo "  PostgreSQL: postgresql://seashop:seashop_secret_change_me@localhost:5432/seashop_dev"
    echo "  PgBouncer:  postgresql://seashop:seashop_secret_change_me@localhost:6432/seashop_dev"
    echo "  Redis:      redis://localhost:6379"
    ;;
  2)
    echo "🚀 Build và khởi động Full Stack..."
    docker compose -f "$DOCKER_DIR/docker-compose.yml" up --build -d
    echo ""
    echo "✅ Full Stack đã sẵn sàng!"
    echo ""
    echo "🌐 URLs:"
    echo "  Store:    http://localhost"
    echo "  Admin:    http://localhost/admin"
    echo "  API:      http://localhost/api/v1"
    echo "  Health:   http://localhost/health"
    ;;
  *)
    echo "❌ Lựa chọn không hợp lệ"
    exit 1
    ;;
esac
