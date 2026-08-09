FROM nginx
RUN apt update && apt install -y certbot python3-certbot-nginx
VOLUME /etc/letsencrypt/live
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT /entrypoint.sh