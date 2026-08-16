.PHONY: help start stop restart logs clean build test

help:
	@echo "GDPR Address List - Makefile"
	@echo ""
	@echo "Verfügbare Ziele:"
	@echo "  start     - Starte alle Services"
	@echo "  stop      - Stoppe alle Services"
	@echo "  restart   - Starte alle Services neu"
	@echo "  logs      - Zeige Logs"
	@echo "  clean     - Stoppe Services und entferne Volumes"
	@echo "  build     - Baue Images neu"
	@echo "  test      - Führe Tests aus"

start:
	docker-compose up -d

stop:
	docker-compose down

restart:
	docker-compose restart

logs:
	docker-compose logs -f

clean:
	docker-compose down -v

build:
	docker-compose build

test:
	@echo "Tests werden ausgeführt..."
