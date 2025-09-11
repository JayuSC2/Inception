FROM debian:bookworm

RUN apt-get update && apt-get install -y mariadb-server mariadb-client \
	&& rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y gettext

RUN mkdir -p /var/lib/mysql && chown -R mysql:mysql /var/lib/mysql

RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

WORKDIR /var/lib/mysql

COPY 50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY init.sql /init.sql

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 3306

CMD ["/entrypoint.sh"]