FROM debian:bookworm

RUN apt-get update && apt-get install -y nginx openssl \
	&& rm -rf /var/lib/apt/lists/*

COPY nginx.conf /etc/nginx/nginx.conf

RUN rm -f /etc/nginx/sites-enabled/default

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 443

CMD ["/entrypoint.sh"]