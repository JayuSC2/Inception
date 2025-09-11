FROM debian:bookworm

# Install PHP 8.2 and other dependencies
RUN apt-get update && apt-get install -y \
    curl \
    php8.2 \
    php8.2-fpm \
    php8.2-mysql \
    mariadb-client \
    netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

# Download and extract WordPress
RUN curl -o /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz && \
    tar -xzf /tmp/wordpress.tar.gz -C /usr/src/ && \
    rm /tmp/wordpress.tar.gz

# Download wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

RUN mkdir -p /var/www/html

# Create and set permissions for the PHP-FPM run directory
RUN mkdir -p /run/php && chown www-data:www-data /run/php

# Configure PHP-FPM for Docker logging, using the correct path for PHP 8.2
# Force logs to stderr
RUN sed -i 's#;error_log = log/php-fpm.log#error_log = /proc/self/fd/2#' /etc/php/8.2/fpm/php-fpm.conf
# Ensure workers output is caught
RUN sed -i 's#;catch_workers_output = yes#catch_workers_output = yes#' /etc/php/8.2/fpm/pool.d/www.conf
# Set listen port
RUN sed -i 's/listen = \/run\/php\/php8.2-fpm.sock/listen = 9000/' /etc/php/8.2/fpm/pool.d/www.conf

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Use the correct executable for PHP 8.2
CMD ["php-fpm8.2", "-F"]

EXPOSE 9000

#FROM debian:bookworm
#
#RUN apt-get update && apt-get install -y \
#    curl \
#    php7.4 \
#    php7.4-fpm \
#    php7.4-mysql \
#    mariadb-client \
#    netcat-openbsd \
#    && rm -rf /var/lib/apt/lists/*
#
#RUN curl -o /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz && \
#    tar -xzf /tmp/wordpress.tar.gz -C /usr/src/ && \
#    rm /tmp/wordpress.tar.gz
#
## Also download wp-cli
#RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
#    chmod +x wp-cli.phar && \
#    mv wp-cli.phar /usr/local/bin/wp
#
#RUN mkdir -p /var/www/html
#
#RUN mkdir -p /run/php && chown www-data:www-data /run/php
## 4. Configure PHP-FPM for Docker logging
## Force logs to stderr
#RUN sed -i 's#;error_log = log/php-fpm.log#error_log = /proc/self/fd/2#' /etc/php/7.4/fpm/php-fpm.conf
## Ensure workers output is caught
#RUN sed -i 's#;catch_workers_output = yes#catch_workers_output = yes#' /etc/php/7.4/fpm/pool.d/www.conf
## Set listen port
#RUN sed -i 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 9000/' /etc/php/7.4/fpm/pool.d/www.conf
#
#COPY entrypoint.sh /usr/local/bin/
#RUN chmod +x /usr/local/bin/entrypoint.sh
#ENTRYPOINT ["entrypoint.sh"]
#CMD ["php-fpm7.4", "-F"]
#
##RUN chown -R www-data:www-data /var/www/html && \
##    mkdir -p /run/php && \
##    chown www-data:www-data /run/php
#
#EXPOSE 9000