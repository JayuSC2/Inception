#!/bin/bash

WP_PATH="/var/www/html"

echo "Waiting for MariaDB to be ready..."
for i in {1..30}; do
    if wp db check --path="$WP_PATH" --allow-root --dbhost="mariadb" --dbuser="$MYSQL_USER" --dbpass="$MYSQL_PASSWORD" > /dev/null 2>&1; then
        echo "MariaDB is up and running!"
        break
    fi
    echo "MariaDB not ready yet... waiting..."
    sleep 1
done
# Check if WordPress is already installed
if ! wp core is-installed --path="$WP_PATH" --allow-root; then
    echo "WordPress not found. Installing..."

    wp core download --path="$WP_PATH" --allow-root

    wp config create --path="$WP_PATH" \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost="mariadb" \
        --allow-root

    wp core install --path="$WP_PATH" \
        --url="$DOMAIN_NAME" \
        --title="My WordPress Site" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --allow-root

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