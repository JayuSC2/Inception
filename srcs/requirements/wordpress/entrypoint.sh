#!/bin/bash
set -e

WP_PATH="/var/www/html"

if [ ! -f "$WP_PATH/wp-config-sample.php" ]; then
    echo "WordPress not found in volume. Copying files..."
    cp -r /usr/src/wordpress/* "$WP_PATH/"
fi

chown -R www-data:www-data "$WP_PATH"

if [ ! -f "$WP_PATH/wp-config.php" ]; then
    echo "Configuring WordPress for the first time..."

    DB_PASSWORD=$(cat "$WORDPRESS_DB_PASSWORD_FILE")
    WP_ADMIN_PASSWORD=$(cat "$WP_ADMIN_PASSWORD_FILE")
    WP_USER_PASSWORD=$(cat "$WP_USER_PASSWORD_FILE")

    echo "Waiting for MariaDB database..."
    until mysql -h"mariadb" -u"${MYSQL_USER}" -p"${DB_PASSWORD}" -e "quit"; do
        sleep 1
        echo -n "."
    done
    echo "MariaDB is ready."

    wp config create --dbname="${MYSQL_DATABASE}" \
                     --dbuser="${MYSQL_USER}" \
                     --dbpass="${DB_PASSWORD}" \
                     --dbhost="mariadb" \
                     --path="${WP_PATH}" \
                     --allow-root

    wp core install --url="${DOMAIN_NAME}" \
                    --title="Inception" \
                    --admin_user="${WP_ADMIN_USER}" \
                    --admin_password="${WP_ADMIN_PASSWORD}" \
                    --admin_email="${WP_ADMIN_EMAIL}" \
                    --path="${WP_PATH}" \
                    --allow-root

    wp user create "${WP_USER}" "${WP_USER_EMAIL}" --role=author --user_pass="${WP_USER_PASSWORD}" --path="${WP_PATH}" --allow-root

else
    echo "WordPress is already configured."
fi

echo "Starting PHP-FPM..."
exec "$@"