Write-Host "🚀 Memulai setup aplikasi Laravel dengan Docker..."

# Pindah ke root proyek
Set-Location -Path (Resolve-Path "$PSScriptRoot\..")

# Cek .env
if (-Not (Test-Path ".env")) {
    Write-Host "📄 Menyalin .env.example ke .env..."
    Copy-Item ".env.example" ".env"
}

# Jalankan docker compose
Write-Host "🐳 Menjalankan docker compose..."
docker compose -f compose.dev.yaml up --build -d

# Tunggu 10 detik
Write-Host "⏳ Menunggu container Laravel siap..."
Start-Sleep -Seconds 10

# Set permission (tidak berpengaruh di Windows host, tapi tetap dicoba)
Write-Host "🔧 Menyetel permission folder storage dan cache..."
docker compose exec app chown -R www-data:www-data storage bootstrap/cache
docker compose exec app chmod -R 775 storage bootstrap/cache

# Install dependensi
Write-Host "📦 Menginstall dependensi Composer..."
docker compose exec app composer install --no-interaction --optimize-autoloader

# Generate app key
Write-Host "🔐 Mengenerate key aplikasi Laravel..."
docker compose exec app php artisan key:generate

# Migrasi
Write-Host "🛠️ Menjalankan migrasi database..."
docker compose exec app php artisan migrate

Write-Host "✅ Setup selesai! Laravel tersedia di http://localhost:8000"
Write-Host "🧹 Untuk menghentikan: docker compose down"
Pause
