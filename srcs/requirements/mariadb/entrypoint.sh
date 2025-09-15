#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

DATA_DIR="/var/lib/mysql"

# This script only runs on the first-time creation of the volume.
#if [ ! -d "$DATA_DIR/mysql" ]; then
    echo "Database not initialized. Starting first-time setup..."

    # 1. Initialize the database directory.
    mysql_install_db --user=mysql --datadir="$DATA_DIR"

    # 2. Read passwords from the secret files into shell variables.
    # The file paths are passed via the 'environment' block in docker-compose.yml
    DB_ROOT_PASSWORD=$(cat "$MYSQL_ROOT_PASSWORD_FILE")
    DB_PASSWORD=$(cat "$MYSQL_PASSWORD_FILE")

    # 3. Create a temporary SQL file with the setup commands.
    cat << EOF > /tmp/init.sql
    -- Use mysql database to modify users
    USE mysql;
    -- Set the root password securely
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
    -- Remove anonymous users for security
    DELETE FROM mysql.user WHERE User='';
    -- Disallow remote root login
    DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
    -- Create the WordPress database if it doesn't exist
    CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
    -- Create the WordPress user, allowing connection from ANY host ('%')
    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
    -- Grant all necessary privileges to the user for the WordPress database
    GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%' WITH GRANT OPTION;
    -- Apply all the changes
    FLUSH PRIVILEGES;
EOF

    # 4. Start the MariaDB server, telling it to run the init file.
    echo "Starting MariaDB with initialization script..."
    exec mysqld --user=mysql --datadir="$DATA_DIR" --init-file=/tmp/init.sql

#else
#    echo "Database already initialized. Skipping setup."
#fi

# If the database was already initialized, start the server normally.
echo "Starting MariaDB server..."
exec mysqld --user=mysql --datadir="$DATA_DIR"

## Exit immediately if a command exits with a non-zero status
#set -e
#
#DATA_DIR="/var/lib/mysql"
#
## This script only runs on the first-time creation of the volume.
#if [ ! -d "$DATA_DIR/mysql" ]; then
#    echo "Database not initialized. Starting first-time setup..."
#
#    # Initialize the database directory
#    mysql_install_db --user=mysql --datadir="$DATA_DIR"
#
#    # Start the server in the background to perform setup
#    mysqld --user=mysql --datadir="$DATA_DIR" &
#    PID=$!
#
#    # Wait for the server to be ready
#    for i in {30..0}; do
#        if mysqladmin ping -h localhost --silent; then
#            break
#        fi
#        echo "Waiting for database server to start..."
#        sleep 1
#    done
#    if [ "$i" -eq 0 ]; then
#        echo "Database server failed to start."
#        exit 1
#    fi
#
#    # Read passwords from the secret files mounted by Docker Compose
#    MYSQL_ROOT_PASSWORD=$(cat "$MYSQL_ROOT_PASSWORD_FILE")
#    MYSQL_PASSWORD=$(cat "$MYSQL_PASSWORD_FILE")
#
#    # Use a 'here document' to execute a series of SQL commands
#    mysql -u root <<EOF
#        -- Set the root password securely
#        ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
#        -- Create the WordPress database if it doesn't exist
#        CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
#        -- Create the WordPress user if it doesn't exist, allowing connection from any host ('%')
#        CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
#        -- Grant all necessary privileges to the user for the WordPress database
#        GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
#        -- Apply the changes
#        FLUSH PRIVILEGES;
#EOF
#
#    # Stop the temporary server
#    if ! mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown; then
#        echo "Failed to shut down temporary database server."
#        kill -9 "$PID"
#    fi
#    
#    echo "First-time database setup complete."
#else
#    echo "Database already initialized. Skipping setup."
#fi
#
## Clean up stale lock files from any previous unclean shutdown
#rm -f /var/lib/mysql/mysqld.pid
#rm -f /var/lib/mysql/aria_log_control
#
## Create the run directory for the socket file
#mkdir -p /run/mysqld
#chown -R mysql:mysql /run/mysqld
#
## Start the MariaDB server in the foreground as the main container process
#echo "Starting MariaDB server..."
#exec mysqld --user=mysql --datadir="$DATA_DIR"

##!/bin/bash
#
#set -e 
#
#DATA_DIR="/var/lib/mysql"
#
## Check if the database is already initialized by looking for the wordpress directory
#if [ ! -d "$DATA_DIR/mysql" ]; then
#    echo "Database not found. Initializing..."
#
#    # 1. Initialize the MariaDB data directory
#    mysql_install_db --user=mysql --datadir="$DATA_DIR"
#
#    # 2. Start the MariaDB server in the background temporarily
#    mysqld --user=mysql --datadir="$DATA_DIR" &
#    PID=$! # Get the process ID of the server
#
#    # 3. Wait for the server to be ready for connections
#    until mysqladmin ping >/dev/null 2>&1; do
#        echo -n "."; sleep 1
#    done
#    echo " MariaDB is ready."
#
#    # 4. Read passwords from the secret files
#    DB_PASSWORD=$(cat "$MYSQL_PASSWORD_FILE")
#    DB_ROOT_PASSWORD=$(cat "$MYSQL_ROOT_PASSWORD_FILE")
#
#    # 5. Execute SQL commands to set up the database, user, and passwords
#    mysql -u root <<-EOF
#        -- Set the root password securely
#        ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
#        -- Create the WordPress database if it doesn't exist
#        CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
#        -- Create the WordPress user if it doesn't exist, allowing connection from any host ('%')
#        CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
#        -- Grant all necessary privileges to the user for the WordPress database
#        GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
#        -- Apply the changes
#        FLUSH PRIVILEGES;
#EOF
#
#
#    # 6. Stop the temporary server
#    mysqladmin -u root -p"${DB_ROOT_PASSWORD}" shutdown
#    wait $PID
#    echo "Database initialization complete."
#fi
#
## Start the MariaDB server in the foreground.
## 'exec' replaces the script process with the mysqld process.
#echo "Starting MariaDB..."
#mkdir -p /run/mysqld
#chown mysql:mysql /run/mysqld
#exec mysqld --user=mysql --datadir="$DATA_DIR"