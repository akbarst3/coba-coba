@echo off
setlocal

echo 🚀 Menjalankan setup Laravel secara lokal...

:: Cek .env
if not exist ".env" (
    echo 📄 Menyalin .env.example ke .env...
    copy .env.example .env
)

:: Install Composer
echo 📦 Menginstall dependensi Composer...
composer install --no-interaction --optimize-autoloader

:: Generate key
echo 🔐 Mengenerate app key...
php artisan key:generate

:: Migrasi database
echo 🛠️ Menjalankan migrasi database...
php artisan migrate

echo ✅ Setup selesai! Jalankan: php artisan serve

endlocal
pause
