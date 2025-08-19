FROM nginx:1.26.1-alpine

# The nginx:alpine image uses the 'apk' package manager.
# Install openssl so we can generate certificates.
RUN apk update && apk add --no-cache openssl

# Copy your custom nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Copy the startup script into the container
COPY entrypoint.sh /entrypoint.sh

# Make the script executable
RUN chmod +x /entrypoint.sh

EXPOSE 443

# Set the startup script as the command to run when the container starts.
CMD ["/entrypoint.sh"]