# Civika – Civitas Akademika JTK

CIVIKA adalah sebuah aplikasi berbasis web yang dirancang untuk membantu Jurusan Teknik Komputer dan Informatika Polban dalam mengelola data mahasiswa secara terpusat, efisien, dan terstruktur. Aplikasi ini mendukung pengelolaan data akademik, statistik nilai akademik mahasiswa, hingga pengajuan surat resmi secara digital.

---

## Instalasi Menggunakan Docker / Lokal

### 📁 Struktur Folder
```
civika/
├── docker/
├─────development/
├───────Dockerfile
├───init/
├─────docker/
├───────init.sh
├───────init.bat
├───────init.ps1
├─────local/
├───────init.sh
├───────init.bat
├───────init.ps1
└── compose.dev.yaml
```

### 🐳 Langkah-langkah instalasi dengan Docker Containerize
- **Command Prompt**
   ```bash
   init\docker\init.bat
- **Powershell**
   ```bash
   .\init\docker\init.ps1
- **UNIX (Linux, WSL, macOS)**
   ```bash
   ./init/docker/init.sh

### 🏡 Langkah-langkah instalasi Lokal
#### 1. Setup database PostgreSQL  
    a. Pastikan PostgreSQL sudah terinstal di sistem  
    b. Buat database baru dengan nama `civika_db`
    c. Sesuaikan konfigurasi username dan password pada .env.example

#### 2. Init Project
- **Command Prompt**
   ```bash
   init\local\init.bat
- **Powershell**
   ```bash
   .\init\local\init.ps1
- **UNIX (Linux, WSL, macOS)**
   ```bash
   ./init/local/init.sh

## Command-command Penting (Docker)
-  **Composer install** => scripts\install.bat
-  **Logging App** => scripts\logs.bat
-  **Migrasi Database** => scripts\migrate.bat
-  **Restart Container** => scripts\restart.bat
-  **Seeding Database** => scripts\seed.bat
-  **Stop Container** => scripts\stop.bat
-  **Start Container** => scripts\start.bat
### Powershell
-  **Composer install** => .\scripts\install.ps1
-  **Logging App** => .\scripts\logs.ps1
-  **Migrasi Database** => .\scripts\migrate.ps1
-  **Restart Container** => .\scripts\restart.ps1
-  **Seeding Database** => .\scripts\seed.ps1
-  **Stop Container** => .\scripts\stop.ps1
-  **Start Container** => .\scripts\start.ps1
### UNIX (Linux, WSL, macOS)
-  **Composer install** => make install
-  **Logging App** => make logs
-  **Migrasi Database** => make migrate
-  **Restart Container** => make restart
-  **Seeding Database** => make seed
-  **Stop Container** => make stop
-  **Start Container** => make up
