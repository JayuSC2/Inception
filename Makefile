up:
	docker compose up	-d	--build

down:
	docker compose down

build:
	docker compose	build

clean:
	docker compose down -v

.PHONY: up down build clean