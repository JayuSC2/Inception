CERT_PATH="/etc/nginx/ssl/nginx.crt"
KEY_PATH="/etc/nginx/ssl/nginx.key"

# Generate the certificate and key if they don't exist
if [ ! -f "$CERT_PATH" ] || [ ! -f "$KEY_PATH" ]; then
  echo "Generating self-signed SSL certificate..."
  
  # Create the directory for the certs
  mkdir -p /etc/nginx/ssl
  
  # Generate the files using openssl
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout "$KEY_PATH" -out "$CERT_PATH" \
    -subj "/C=US/ST=NewYork/L=NewYork/O=42/CN=juitz.42.fr"
fi

# Start NGINX in the foreground.
# The 'exec' command replaces the script process with the nginx process,
# which is the correct way to run the main service in a container.
exec nginx -g "daemon off;"