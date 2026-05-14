# Makefile for PI-Cloud Documentation

.PHONY: help build rebuild up down restart logs status ps serve open build-site watch lint lint-fix check validate clean clean-all prune shell

# Colors for output
GREEN := \033[0;32m
YELLOW := \033[1;33m
RED := \033[0;31m
NC := \033[0m # No Color

# Default port
PORT ?= 8001

help: ## Show this help message
	@printf "${GREEN}PI-Cloud Documentation - Available Commands${NC}\n\n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  ${YELLOW}%-15s${NC} %s\n", $$1, $$2}'
	@printf "\n${GREEN}Example usage:${NC}\n"
	@printf "  make build    # Build Docker images\n"
	@printf "  make up       # Start documentation server\n"
	@printf "  make open     # Open in browser\n\n"

# Build & Setup
build: ## Build Docker images
	@printf "${GREEN}Building Docker images...${NC}\n"
	docker compose build

rebuild: ## Force rebuild Docker images without cache
	@printf "${YELLOW}Rebuilding Docker images without cache...${NC}\n"
	docker compose build --no-cache

pull: ## Pull latest base images
	@printf "${GREEN}Pulling latest images...${NC}\n"
	docker compose pull

# Server Management
up: ## Start documentation server in background
	@printf "${GREEN}Starting documentation server on port ${PORT}...${NC}\n"
	PORT=$(PORT) docker compose up -d
	@printf "${GREEN}Documentation available at: http://localhost:${PORT}${NC}\n"

down: ## Stop all containers
	@printf "${YELLOW}Stopping containers...${NC}\n"
	docker compose down

restart: down up ## Restart documentation server

logs: ## View real-time logs
	@printf "${GREEN}Showing logs (Ctrl+C to exit)...${NC}\n"
	docker compose logs -f

status: ## Show container status
	@printf "${GREEN}Container status:${NC}\n"
	docker compose ps

ps: status ## Alias for status

# Documentation Development
serve: ## Start server with live reload (foreground)
	@printf "${GREEN}Starting documentation server on port ${PORT}...${NC}\n"
	@printf "${YELLOW}Press Ctrl+C to stop${NC}\n"
	PORT=$(PORT) docker compose up mkdocs

open: ## Open documentation in default browser
	@printf "${GREEN}Opening documentation in browser...${NC}\n"
	@if command -v xdg-open > /dev/null; then \
		xdg-open http://localhost:${PORT}; \
	elif command -v open > /dev/null; then \
		open http://localhost:${PORT}; \
	elif command -v start > /dev/null; then \
		start http://localhost:${PORT}; \
	else \
		printf "${YELLOW}Please open http://localhost:${PORT} manually${NC}\n"; \
	fi

build-site: ## Build static HTML site
	@printf "${GREEN}Building static site...${NC}\n"
	docker compose run --rm mkdocs build
	@printf "${GREEN}Site built in 'site/' directory${NC}\n"

watch: ## Watch for changes and auto-rebuild
	@printf "${GREEN}Watching for changes...${NC}\n"
	docker compose run --rm mkdocs build --watch

# Quality & Linting
lint: ## Run markdownlint on all markdown files
	@printf "${GREEN}Running markdownlint...${NC}\n"
	docker compose run --rm markdownlint docs/**/*.md || true

lint-fix: ## Auto-fix linting issues
	@printf "${GREEN}Auto-fixing linting issues...${NC}\n"
	docker compose run --rm markdownlint --fix docs/**/*.md || true

check: lint ## Run all quality checks
	@printf "${GREEN}Running all quality checks...${NC}\n"
	@printf "${YELLOW}Checking markdown files...${NC}\n"
	docker compose run --rm markdownlint docs/**/*.md

validate: ## Validate mkdocs.yml configuration
	@printf "${GREEN}Validating mkdocs.yml...${NC}\n"
	docker compose run --rm mkdocs build --strict

# Maintenance
clean: ## Remove build cache and temporary files
	@printf "${YELLOW}Cleaning temporary files...${NC}\n"
	rm -rf site/
	rm -rf __pycache__/
	rm -rf .cache/
	@printf "${GREEN}Clean complete${NC}\n"

clean-all: down clean ## Remove all containers, images, and volumes
	@printf "${RED}Removing all containers, images, and volumes...${NC}\n"
	docker compose down -v --rmi all
	@printf "${GREEN}Clean complete${NC}\n"

prune: ## Remove unused Docker resources
	@printf "${YELLOW}Pruning unused Docker resources...${NC}\n"
	docker system prune -f

shell: ## Open shell in MkDocs container
	@printf "${GREEN}Opening shell in MkDocs container...${NC}\n"
	docker compose run --rm mkdocs sh

# Default target
.DEFAULT_GOAL := help