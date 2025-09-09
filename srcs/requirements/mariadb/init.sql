-- Use the 'mysql' database to manage users and privileges.
USE mysql;

-- Apply any pending changes to the grant tables.
FLUSH PRIVILEGES;

-- Set the password for the 'root' user at 'localhost'.
-- Note the correct ${VAR} syntax for envsubst.
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

-- Create the main database for WordPress.
CREATE DATABASE IF NOT EXISTS `${MYSQL_DATABASE}`;

-- Create the user for WordPress, allowing connection from any host ('%').
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
-- Grant all privileges on the WordPress database to the new user.
GRANT ALL PRIVILEGES ON `${MYSQL_DATABASE}`.* TO '${MYSQL_USER}'@'%';

-- ALSO create the user for connections from localhost.
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';
-- Grant privileges for the localhost user as well.
GRANT ALL PRIVILEGES ON `${MYSQL_DATABASE}`.* TO '${MYSQL_USER}'@'localhost';

-- Apply the privilege changes immediately.
FLUSH PRIVILEGES;