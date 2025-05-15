Write-Host "🚀 Memulai setup aplikasi Laravel dengan Docker..."

# Cek .env
if (-not (Test-Path -Path ".env")) {
    Write-Host "📄 Menyalin .env.example ke .env..."
    Copy-Item -Path ".env.example" -Destination ".env"
} else {
    Write-Host "✅ .env sudah ada."
}

# Build & up docker-compose
Write-Host "🐳 Menjalankan docker compose..."
docker compose -f compose.dev.yaml up --build -d

# Tunggu container app jalan
Write-Host "⏳ Menunggu container Laravel siap..."
do {
    $status = docker inspect -f '{{.State.Status}}' laravel_app 2>$null
    Start-Sleep -Seconds 2
} while ($status -ne "running")

Write-Host "✅ Container laravel_app aktif!"

# Cek folder vendor
if (-not (Test-Path -Path "vendor")) {
    Write-Host "📦 Folder vendor belum ada, menjalankan composer install..."
    docker compose exec app composer install --no-interaction --optimize-autoloader
} else {
    Write-Host "✅ Folder vendor sudah ada."
}

# Set permission (tidak fatal di Windows)
Write-Host "🔧 Menyetel permission folder storage dan cache..."
docker compose exec app sh -c "chown -R www-data:www-data storage bootstrap/cache && chmod -R 775 storage bootstrap/cache"

# Generate key Laravel
Write-Host "🔐 Mengenerate key aplikasi Laravel..."
docker compose exec app php artisan key:generate

# Migrasi database
Write-Host "🛠️ Menjalankan migrasi database..."
docker compose exec app php artisan migrate

# Jalankan Laravel server di background
Write-Host "🚀 Menjalankan Laravel server di port 8000..."
docker compose exec -d app php artisan serve --host=0.0.0.0 --port=8000

Write-Host "✅ Setup selesai! Laravel tersedia di http://localhost:8000"
Write-Host "🧹 Untuk menghentikan: docker compose down"

Pause
