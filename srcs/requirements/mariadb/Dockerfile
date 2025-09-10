FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server mariadb-client \
	&& rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y gettext

RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

COPY 50-server.cnf etc/mysql/mariadb.conf.d/50-server.cnf

COPY init.sql /init.sql

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 3306

CMD ["/entrypoint.sh"]