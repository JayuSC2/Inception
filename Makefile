# The 'up' command builds the images (if they don't exist) and starts the containers.
# The '-d' flag runs them in detached mode (in the background).
up:
	docker compose up	-d	--build

# The 'down' command stops and removes the containers and networks.
down:
	docker compose down

# The 'build' command forces a rebuild of all the images.
build:
	docker compose	build

# The 'clean' command stops the containers and removes them, along with the volumes.
# This is useful for a complete reset.
clean:
	docker compose down -v

# A phony target tells Make that these are not actual files.
.PHONY: up down build clean