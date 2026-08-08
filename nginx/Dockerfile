FROM nginx
RUN apt update && apt install -y certbot python3-certbot-nginx
COPY ./nginx.conf /etc/nginx/nginx.conf
