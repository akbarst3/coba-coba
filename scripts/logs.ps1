Write-Host "📜 Menampilkan log container app..."
docker compose -f compose.dev.yaml logs -f app
