DATA_DIR="/var/lib/mysql"

# Check if the database is already initialized by looking for the wordpress directory
if [ ! -d "$DATA_DIR/$MYSQL_DATABASE" ]; then
    echo "Database not found. Initializing..."

    # 1. Initialize the MariaDB data directory
    mysql_install_db --user=mysql --datadir="$DATA_DIR"

    # 2. Start the MariaDB server in the background temporarily
    mysqld --user=mysql --datadir="$DATA_DIR" --skip-networking &
    PID=$! # Get the process ID of the server

    # 3. Wait for the server to be ready for connections
    until mysqladmin ping >/dev/null 2>&1; do
        echo -n "."; sleep 1
    done
    echo " MariaDB is ready."

    # 4. Read passwords from the secret files
    DB_PASSWORD=$(cat /run/secrets/db_password)
    DB_ROOT_PASSWORD=$(cat run/secrets/db_root_password)

    # 5. Execute SQL commands to set up the database, user, and passwords
    mysql -u root <<-EOF
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
        DELETE FROM mysql.user WHERE User='';
        DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
        DROP DATABASE IF EXISTS test;
        DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
        CREATE DATABASE ${MYSQL_DATABASE};
        CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
        GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
        FLUSH PRIVILEGES;
    EOF

    # 6. Stop the temporary server
    mysqladmin -u root -p"${DB_ROOT_PASSWORD}" shutdown
    wait $PID
    echo "Database initialization complete."
fi

# Start the MariaDB server in the foreground.
# 'exec' replaces the script process with the mysqld process.
echo "Starting MariaDB..."
exec mysqld --user=mysql --datadir="$DATA_DIR"