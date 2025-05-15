#!/bin/bash
set -e

echo "🚀 Memulai setup aplikasi Laravel dengan Docker..."

# Cek .env
if [ ! -f .env ]; then
  echo "📄 Menyalin .env.example ke .env..."
  cp .env.example .env
else
  echo "✅ .env sudah ada."
fi

# Build & up docker compose
echo "🐳 Menjalankan docker compose..."
docker compose -f compose.dev.yaml up --build -d

# Tunggu container laravel_app jalan
echo "⏳ Menunggu container Laravel siap..."
while [ "$(docker inspect -f '{{.State.Status}}' laravel_app 2>/dev/null)" != "running" ]; do
  sleep 2
done
echo "✅ Container laravel_app aktif!"

# Cek folder vendor
if [ ! -d vendor ]; then
  echo "📦 Folder vendor belum ada, menjalankan composer install..."
  docker compose exec app composer install --no-interaction --optimize-autoloader
else
  echo "✅ Folder vendor sudah ada."
fi

# Set permission
echo "🔧 Menyetel permission folder storage dan cache..."
docker compose exec app sh -c "chown -R www-data:www-data storage bootstrap/cache && chmod -R 775 storage bootstrap/cache"

# Generate key Laravel
echo "🔐 Mengenerate key aplikasi Laravel..."
docker compose exec app php artisan key:generate

# Migrasi database
echo "🛠️ Menjalankan migrasi database..."
docker compose exec app php artisan migrate

# Jalankan Laravel server background
echo "🚀 Menjalankan Laravel server di port 8000..."
docker compose exec -d app php artisan serve --host=0.0.0.0 --port=8000

echo "✅ Setup selesai! Laravel tersedia di http://localhost:8000"
echo "🧹 Untuk menghentikan: docker compose down"
