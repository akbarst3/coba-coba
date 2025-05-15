#!/bin/bash

echo "🚀 Starting Laravel Docker initialization..."

# 1. Copy .env kalau belum ada
if [ ! -f .env ]; then
  echo "📄 Copying .env.example to .env"
  cp .env.example .env
else
  echo "✅ .env already exists, skipping copy"
fi

# 2. Install composer dependencies (di lokal)
if [ ! -d "vendor" ]; then
  echo "📦 Installing Composer dependencies..."
  composer install
else
  echo "✅ Vendor folder already exists, skipping composer install"
fi

# 3. Build and run Docker containers
echo "🐳 Building and starting containers..."
docker-compose up -d --build

# 4. Generate Laravel app key
echo "🔑 Generating Laravel app key..."
docker exec -it laravel-app php artisan key:generate

# 5. Run database migration
echo "🗄️ Running database migrations..."
docker exec -it laravel-app php artisan migrate

echo "✅ Setup complete! Laravel should now be running at http://localhost:8000"
