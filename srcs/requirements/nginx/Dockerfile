FROM debian:bullseye

# Use Debian's package manager 'apt-get' to install nginx and openssl
RUN apt-get update && apt-get install -y nginx openssl

# Copy your custom nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

RUN rm -f /etc/nginx/sites-enabled/default

# Copy the startup script into the container
COPY entrypoint.sh /entrypoint.sh

# Make the script executable
RUN chmod +x /entrypoint.sh

EXPOSE 443

# Set the startup script as the command to run when the container starts.
CMD ["/entrypoint.sh"]