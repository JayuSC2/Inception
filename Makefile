COMPOSE_FILE = srcs/docker-compose.yml

up:
	docker compose --file $(COMPOSE_FILE) up -d --build

down:
	docker compose --file $(COMPOSE_FILE) down

build:
	docker compose --file $(COMPOSE_FILE) build

clean:
	docker compose --file $(COMPOSE_FILE) down -v

re: clean up

.PHONY: up down build clean re
