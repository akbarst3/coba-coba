# =========================
# Laravel Makefile Helper
# =========================

# Default environment (Docker or local)
ENV ?= docker

# Define basic commands for Docker or local
ifeq ($(ENV),docker)
PHP        = docker compose -f compose.dev.yaml exec app php
COMPOSER   = docker compose -f compose.dev.yaml exec app composer
ARTISAN    = $(PHP) artisan
MIGRATE    = $(ARTISAN) migrate
KEYGEN     = $(ARTISAN) key:generate
SERVE      = $(ARTISAN) serve --host=0.0.0.0 --port=8000
DOCKER_COMPOSE = docker compose -f compose.dev.yaml
else
PHP        = php
COMPOSER   = composer
ARTISAN    = $(PHP) artisan
MIGRATE    = $(ARTISAN) migrate
KEYGEN     = $(ARTISAN) key:generate
SERVE      = php artisan serve
DOCKER_COMPOSE = docker compose -f compose.dev.yaml
endif

# =========================
# Commands
# =========================

init:
	@echo "📦 Inisialisasi Laravel ($(ENV))..."
	@if [ ! -f .env ]; then cp .env.example .env; fi
	$(COMPOSER) install --no-interaction --optimize-autoloader
	$(KEYGEN)
	$(MIGRATE)

up:
	$(DOCKER_COMPOSE) up --build -d

down:
	$(DOCKER_COMPOSE) down

restart:
	$(DOCKER_COMPOSE) down
	$(DOCKER_COMPOSE) up -d --remove-orphans

logs:
	$(DOCKER_COMPOSE) logs -f

artisan:
	$(ARTISAN) $(filter-out $@,$(MAKECMDGOALS))

composer:
	$(COMPOSER) $(filter-out $@,$(MAKECMDGOALS))

migrate:
	$(MIGRATE)

keygen:
	$(KEYGEN)

serve:
	$(SERVE)

# Help
help:
	@echo "📘 Laravel Makefile Commands:"
	@echo ""
	@echo "  make up           🔧 Build & start Docker containers"
	@echo "  make down         🛑 Stop Docker containers"
	@echo "  make restart      🔄 Restart Docker containers"
	@echo "  make init         🚀 Init project (.env, composer install, keygen, migrate)"
	@echo "  make artisan ...  🧰 Run Laravel artisan commands (ex: make artisan migrate:fresh)"
	@echo "  make composer ... 📦 Run composer commands (ex: make composer update)"
	@echo "  make logs         📋 Tail container logs"
	@echo "  make serve        🌐 Run Laravel dev server"
	@echo "  ENV=local make X  💻 Run tasks locally instead of in Docker"

# =========================
# Local-only aliases
# =========================

run-local:
	php artisan serve

migrate-local:
	php artisan migrate

fresh-local:
	php artisan migrate:fresh --seed

seed-local:
	php artisan db:seed

lint-local:
	php artisan pint

tinker-local:
	php artisan tinker

test-local:
	php artisan test

init-local:
	@echo "📦 Init lokal Laravel..."
	@if [ ! -f .env ]; then cp .env.example .env; fi
	composer install --no-interaction --optimize-autoloader
	php artisan key:generate
	php artisan migrate
