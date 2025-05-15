#!/bin/bash

set -e

echo "🚀 Memulai setup aplikasi Laravel dengan Docker..."

# Pindah ke direktori root proyek (jika dijalankan dari luar)
cd "$(dirname "$0")/.."

# 1. Cek .env
if [ ! -f .env ]; then
  echo "📄 Menyalin .env.example ke .env..."
  cp .env.example .env
fi

# 2. Jalankan docker-compose
echo "🐳 Menjalankan docker compose..."
docker compose -f compose.dev.yaml up --build -d

# 3. Tunggu container
echo "⏳ Menunggu container Laravel siap..."
sleep 10

# 4. Set permission
echo "🔧 Menyetel permission folder storage dan cache..."
docker compose exec -T app chown -R www-data:www-data storage bootstrap/cache
docker compose exec -T app chmod -R 775 storage bootstrap/cache

# 5. Install Composer dependencies (jika belum)
echo "📦 Menginstall dependensi Composer..."
docker compose exec -T app composer install --no-interaction --optimize-autoloader

# 6. Generate Laravel key
echo "🔐 Menggenerate key aplikasi Laravel..."
docker compose exec -T app php artisan key:generate

# 7. Jalankan migrasi database
echo "🛠️ Menjalankan migrasi database..."
docker compose exec -T app php artisan migrate

echo "✅ Setup selesai! Laravel tersedia di http://localhost:8000"
echo "🧹 Untuk menghentikan: docker compose down"
