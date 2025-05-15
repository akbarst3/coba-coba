Write-Host "🚀 Menjalankan setup Laravel secara lokal..."

# Cek .env
if (-Not (Test-Path ".env")) {
    Write-Host "📄 Menyalin .env.example ke .env..."
    Copy-Item ".env.example" ".env"
}

# Install Composer
Write-Host "📦 Menginstall dependensi Composer..."
composer install --no-interaction --optimize-autoloader

# Generate key
Write-Host "🔐 Mengenerate app key..."
php artisan key:generate

# Migrasi database
Write-Host "🛠️ Menjalankan migrasi database..."
php artisan migrate

Write-Host "✅ Setup selesai! Jalankan: php artisan serve"
Pause