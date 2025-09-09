#!/bin/bash
set -e

WP_PATH="/var/www/html"

# Check if the directory is empty
if [ ! -f "$WP_PATH/wp-config-sample.php" ]; then
    echo "WordPress not found in volume. Copying files..."
    cp -r /usr/src/wordpress/* "$WP_PATH/"
fi

# Set permissions for the volume at runtime
chown -R www-data:www-data "$WP_PATH"

# Check if wp-config.php exists. If not, perform the first-time setup.
if [ ! -f "$WP_PATH/wp-config.php" ]; then
    echo "Configuring WordPress for the first time..."

    # Read the DB password from the secret file
    DB_PASSWORD=$(cat "$WORDPRESS_DB_PASSWORD_FILE")

    # Wait for MariaDB to be ready by trying to connect with our credentials
    echo "Waiting for MariaDB database..."
    until mysql -h mariadb -u "${MYSQL_USER}" -p"${DB_PASSWORD}" -e 'SELECT 1;' &> /dev/null; do
        sleep 1
    done
    echo "MariaDB is ready."

    # Create wp-config.php using wp-cli
    wp config create --dbname="${MYSQL_DATABASE}" \
                     --dbuser="${MYSQL_USER}" \
                     --dbpass="${DB_PASSWORD}" \
                     --dbhost="mariadb" \
                     --path="${WP_PATH}" \
                     --allow-root

    # Install WordPress core tables
    wp core install --url="${DOMAIN_NAME}" \
                    --title="Inception" \
                    --admin_user="${WP_ADMIN_USER}" \
                    --admin_password="${WP_ADMIN_PASSWORD}" \
                    --admin_email="${WP_ADMIN_EMAIL}" \
                    --path="${WP_PATH}" \
                    --allow-root

    # Create the additional non-admin user
    wp user create "${WP_USER}" "${WP_USER_EMAIL}" --role=author --user_pass="${WP_USER_PASSWORD}" --path="${WP_PATH}" --allow-root

else
    echo "WordPress is already configured."
fi

# Execute the command passed to the container (e.g., php-fpm)
echo "Starting PHP-FPM..."
exec "$@"

##!/bin/bash
#
## Exit immediately if a command exits with a non-zero status
#set -e
#
#WP_PATH="/var/www/html"
#
## Read the password from the secret file path provided by the environment variable
#DB_PASSWORD=$(cat "$WORDPRESS_DB_PASSWORD_FILE")
#
## 1. Wait for the database to be ready before proceeding.
#echo "Waiting for MariaDB to be ready..."
#for i in {1..30}; do
#    # Use the password we read from the file in the check
#    if wp db check --path="$WP_PATH" --allow-root --dbhost="mariadb" --dbuser="$MYSQL_USER" --dbpass="$DB_PASSWORD" > /dev/null 2>&1; then
#        echo "MariaDB is up and running!"
#        break
#    fi
#    echo "MariaDB not ready yet... waiting..."
#    sleep 1
#done
#
## 2. Check if wp-config.php exists. If not, perform the first-time setup.
## This is the correct way to check for a new installation.
#if [ ! -f "$WP_PATH/wp-config.php" ]; then
#    echo "wp-config.php not found. Configuring WordPress..."
#
#    # Create wp-config.php using the password from the secret file
#    wp config create --path="$WP_PATH" \
#        --dbname="$MYSQL_DATABASE" \
#        --dbuser="$MYSQL_USER" \
#        --dbpass="$DB_PASSWORD" \
#        --dbhost="mariadb" \
#        --allow-root
#
#    # Install WordPress using the files already present from the Dockerfile
#    wp core install --path="$WP_PATH" \
#        --url="$DOMAIN_NAME" \
#        --title="Inception" \
#        --admin_user="$WP_ADMIN_USER" \
#        --admin_password="$WP_ADMIN_PASSWORD" \
#        --admin_email="$WP_ADMIN_EMAIL" \
#        --allow-root
#
#    # Create a non-admin user
#    wp user create "$WP_USER" "$WP_USER_EMAIL" \
#        --role=author \
#        --user_pass="$WP_USER_PASSWORD" \
#        --path="$WP_PATH" \
#        --allow-root
#
#    echo "WordPress configuration complete."
#else
#    echo "WordPress is already configured."
#fi
#
## 3. Start PHP-FPM in the foreground
#echo "Starting PHP-FPM..."
#exec php-fpm7.4 -F

##!/bin/bash
#
#WP_PATH="/var/www/html"
#DB_PASSWORD=$(cat "$WORDPRESS_DB_PASSWORD_FILE")
#
#echo "Waiting for MariaDB to be ready..."
#for i in {1..30}; do
#    if wp db check --path="$WP_PATH" --allow-root --dbhost="mariadb" --dbuser="$MYSQL_USER" --dbpass="$DB_PASSWORD" > /dev/null 2>&1; then
#        echo "MariaDB is up and running!"
#        break
#    fi
#    echo "MariaDB not ready yet... waiting..."
#    sleep 1
#done
## Check if WordPress is already installed
#if ! wp core is-installed --path="$WP_PATH" --allow-root; then
#    echo "WordPress not found. Installing..."
#
#    wp core download --path="$WP_PATH" --allow-root
#
#    wp config create --path="$WP_PATH" \
#        --dbname="$MYSQL_DATABASE" \
#        --dbuser="$MYSQL_USER" \
#        --dbpass="$DB_PASSWORD" \
#        --dbhost="mariadb" \
#        --allow-root
#
#    wp core install --path="$WP_PATH" \
#        --url="$DOMAIN_NAME" \
#        --title="My WordPress Site" \
#        --admin_user="$WP_ADMIN_USER" \
#        --admin_password="$WP_ADMIN_PASSWORD" \
#        --admin_email="$WP_ADMIN_EMAIL" \
#        --allow-root
#
#    wp user create "$WP_USER" "$WP_USER_EMAIL" \
#        --role=author \
#        --user_pass="$WP_USER_PASSWORD" \
#        --path="$WP_PATH" \
#        --allow-root
#
#    echo "WordPress installation complete."
#else
#    echo "WordPress is already installed."
#fi
#
## Start PHP-FPM in the foreground
#echo "Starting PHP-FPM..."
#exec php-fpm7.4 -F

