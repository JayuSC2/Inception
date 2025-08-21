FROM debian:Bullseye

RUN apt-get update && apt-get install -y mariadb-server mariadb-client

# Copy the startup script that will initialize the database
COPY entrypoint.sh /entrypoint.sh

# Make the script executable
RUN chmod +x /entrypoint.sh

# Expose the default MariaDB port
EXPOSE 3306

# Set the startup script as the command to run when the container starts
CMD ["/entrypoint.sh"]