FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server mariadb-client \
	&& rm -rf /var/lib/apt/lists/*

# Copy the startup script that will initialize the database
COPY entrypoint.sh /entrypoint.sh

COPY 50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Make the script executable
RUN chmod +x /entrypoint.sh

# Expose the default MariaDB port
EXPOSE 3306

# Set the startup script as the command to run when the container starts
CMD ["/entrypoint.sh"]