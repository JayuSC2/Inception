FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    php7.4-fpm \
    php7.4-mysql \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 2. Configure PHP-FPM to listen on a network port instead of a local socket.
#    This is essential so your separate Nginx container can connect to it.
#    We change the default 'listen' directive in the pool configuration file.
RUN sed -i 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 9000/' /etc/php/7.4/fpm/pool.d/www.conf

# 3. Create the directory where the WordPress files will live.
#    This is the standard web root directory.
RUN mkdir -p /var/www/html

# 4. Download and install the latest version of WordPress.
#    - Use curl to download the tarball to a temporary location.
#    - Use tar to extract the contents into the web root directory.
#      '--strip-components=1' is a useful trick to remove the top-level 'wordpress'
#      folder from the archive, placing the files directly in /var/www/html.
#    - Clean up the downloaded archive to keep the image clean.
RUN curl -o /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz \
    && tar -xzf /tmp/wordpress.tar.gz -C /var/www/html --strip-components=1 \
    && rm /tmp/wordpress.tar.gz

# 5. Set the correct ownership for the WordPress files.
#    The 'www-data' user is the default user that the PHP-FPM service runs as on Debian.
#    This user needs to be able to write to these files to manage themes, plugins, and uploads.
RUN chown -R www-data:www-data /var/www/html

# 6. Expose the port that PHP-FPM will listen on.
#    This is mainly for documentation; the actual communication relies on the shared Docker network.
EXPOSE 9000

# 7. Set the default command to start the PHP-FPM service.
#    The '-F' (or --nodaemonize) flag is critical. It forces PHP-FPM to run in the
#    foreground, which is required for a container's main process to keep it alive.

RUN mkdir -p /run/php && chown www-data:www-data /run/php

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

CMD ["php-fpm7.4", "-F"]