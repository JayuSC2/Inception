#!/bin/bash

CERT_PATH="/etc/nginx/ssl/nginx.crt"
KEY_PATH="/etc/nginx/ssl/nginx.key"

if [ ! -f "$CERT_PATH" ] || [ ! -f "$KEY_PATH" ]; then
  echo "Generating self-signed SSL certificate..."
  
  mkdir -p /etc/nginx/ssl
  
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout "$KEY_PATH" -out "$CERT_PATH" \
    -subj "/C=US/ST=NewYork/L=NewYork/O=42/CN=juitz.42.fr"
fi

exec nginx -g "daemon off;"