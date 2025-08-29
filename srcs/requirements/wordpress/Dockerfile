FROM debian:bullseye

# 1. Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    php7.4 \
    php7.4-fpm \
    php7.4-mysql \
    && rm -rf /var/lib/apt/lists/*

# 2. Download and install WordPress
RUN mkdir -p /var/www/html && \
    curl -o /tmp/latest.tar.gz https://wordpress.org/latest.tar.gz \
    && tar -xzf /tmp/latest.tar.gz -C /var/www/html --strip-components=1 \
    && rm /tmp/latest.tar.gz

# 3. Download and install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# 4. Configure PHP-FPM for Docker logging
# Force logs to stderr
RUN sed -i 's#;error_log = log/php-fpm.log#error_log = /proc/self/fd/2#' /etc/php/7.4/fpm/php-fpm.conf
# Ensure workers output is caught
RUN sed -i 's#;catch_workers_output = yes#catch_workers_output = yes#' /etc/php/7.4/fpm/pool.d/www.conf
# Set listen port
RUN sed -i 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 9000/' /etc/php/7.4/fpm/pool.d/www.conf

# 5. Set up entrypoint
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# 6. Set permissions and create run directory
RUN chown -R www-data:www-data /var/www/html && \
    mkdir -p /run/php && \
    chown www-data:www-data /run/php

EXPOSE 9000