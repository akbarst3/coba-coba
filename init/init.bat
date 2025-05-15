@echo off
echo 🚀 Starting Laravel Docker initialization...

:: 1. Copy .env.example to .env if .env belum ada
if not exist ".env" (
    echo 📄 Copying .env.example to .env
    copy /Y .env.example .env
) else (
    echo ✅ .env already exists, skipping copy
)

:: 2. Install composer dependencies (lokal)
if not exist "vendor" (
    echo 📦 Installing Composer dependencies...
    composer install
) else (
    echo ✅ Vendor folder already exists, skipping composer install
)

:: 3. Build and run Docker containers
echo 🐳 Building and starting containers...
docker-compose up -d --build

:: 4. Generate Laravel app key
echo 🔑 Generating Laravel app key...
docker exec -it laravel-app php artisan key:generate

:: 5. Run database migration
echo 🗄️ Running database migrations...
docker exec -it laravel-app php artisan migrate

echo ✅ Setup complete! Laravel should now be running at http://localhost:8000
pause
