#!/bin/bash

# Define the WordPress path
WP_PATH="/var/www/html"

# Wait a bit for MariaDB to be ready
sleep 10

# Check if WordPress is already installed
if ! wp core is-installed --path="$WP_PATH" --allow-root; then
    echo "WordPress not found. Installing..."

    # Download WordPress core files
    wp core download --path="$WP_PATH" --allow-root

    # Create wp-config.php
    wp config create --path="$WP_PATH" \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost="mariadb" \
        --allow-root

    # Install WordPress
    wp core install --path="$WP_PATH" \
        --url="$DOMAIN_NAME" \
        --title="My WordPress Site" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --allow-root

    # Create a non-admin user
    wp user create "$WP_USER" "$WP_USER_EMAIL" \
        --role=author \
        --user_pass="$WP_USER_PASSWORD" \
        --path="$WP_PATH" \
        --allow-root

    echo "WordPress installation complete."
else
    echo "WordPress is already installed."
fi

# Start PHP-FPM in the foreground
echo "Starting PHP-FPM..."
exec php-fpm7.4 -F