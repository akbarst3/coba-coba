@echo off
setlocal

echo 🚀 Memulai setup aplikasi Laravel dengan Docker...

:: Cek .env
if not exist ".env" (
    echo 📄 Menyalin .env.example ke .env...
    copy .env.example .env >nul
)

:: Build dan jalankan container tanpa artisan serve
echo 🐳 Menjalankan docker compose...
docker compose -f compose.dev.yaml up --build -d

:: Tunggu container app aktif
echo ⏳ Menunggu container Laravel siap...
:wait_for_container
docker inspect -f "status={{.State.Status}}" laravel_app 2>nul | findstr "running" >nul
if errorlevel 1 (
    timeout /t 2 >nul
    goto wait_for_container
)
echo ✅ Container laravel_app aktif!

:: Install composer dependencies jika vendor belum ada
if not exist "vendor" (
    echo 📦 Menjalankan composer install...
    docker compose exec app composer install --no-interaction --optimize-autoloader
) else (
    echo ✅ Folder vendor sudah ada.
)

:: Set permission (tidak fatal di Windows)
echo 🔧 Menyetel permission folder storage dan cache...
docker compose exec app sh -c "chown -R www-data:www-data storage bootstrap/cache && chmod -R 775 storage bootstrap/cache"

:: Generate Laravel key
echo 🔐 Menggenerate key aplikasi Laravel...
docker compose exec app php artisan key:generate

:: Migrasi database
echo 🛠️ Menjalankan migrasi database...
docker compose exec app php artisan migrate

:: Jalankan Laravel server manual
echo 🚀 Menjalankan Laravel server di port 8000...
docker compose exec -d app php artisan serve --host=0.0.0.0 --port=8000

echo ✅ Setup selesai! Laravel tersedia di http://localhost:8000
echo 🧹 Untuk menghentikan: docker compose down

endlocal
pause
