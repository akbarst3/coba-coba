@echo off
setlocal

echo 🚀 Memulai setup aplikasi Laravel dengan Docker...

:: Cek .env
if not exist ".env" (
    echo 📄 Menyalin .env.example ke .env...
    copy .env.example .env
)

:: Jalankan docker compose
echo 🐳 Menjalankan docker compose...
docker compose -f compose.dev.yaml up --build -d

:: Tunggu sebentar agar container siap
echo ⏳ Menunggu container Laravel siap...
timeout /t 10 >nul

:: Set permission (tidak berlaku penuh di Windows, tapi tetap dicoba)
echo 🔧 Menyetel permission folder storage dan cache...
docker compose exec app chown -R www-data:www-data storage bootstrap/cache
docker compose exec app chmod -R 775 storage bootstrap/cache

:: Install composer dependencies
echo 📦 Menginstall dependensi Composer...
docker compose exec app composer install --no-interaction --optimize-autoloader

:: Generate Laravel key
echo 🔐 Mengenerate key aplikasi Laravel...
docker compose exec app php artisan key:generate

:: Migrasi database
echo 🛠️ Menjalankan migrasi database...
docker compose exec app php artisan migrate

echo ✅ Setup selesai! Laravel tersedia di http://localhost:8000
echo 🧹 Untuk menghentikan: docker compose down

endlocal
pause
