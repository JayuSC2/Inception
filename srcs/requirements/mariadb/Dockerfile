FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server mariadb-client \
	&& rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y gettext

COPY 50-server.cnf etc/mysql/mariadb.conf.d/50-server.cnf

COPY entrypoint.sh /entrypoint.sh

COPY init.sql /init.sql

RUN chmod +x /entrypoint.sh

EXPOSE 3306

CMD ["/entrypoint.sh"]