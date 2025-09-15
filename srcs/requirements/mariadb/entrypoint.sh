#!/bin/bash

set -e

DATA_DIR="/var/lib/mysql"

echo "Database not initialized. Starting first-time setup..."

mysql_install_db --user=mysql --datadir="$DATA_DIR"

DB_ROOT_PASSWORD=$(cat "$MYSQL_ROOT_PASSWORD_FILE")
DB_PASSWORD=$(cat "$MYSQL_PASSWORD_FILE")

cat << EOF > /tmp/init.sql
USE mysql;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

echo "Starting MariaDB with initialization script..."
exec mysqld --user=mysql --datadir="$DATA_DIR" --init-file=/tmp/init.sql

echo "Starting MariaDB server..."
exec mysqld --user=mysql --datadir="$DATA_DIR"