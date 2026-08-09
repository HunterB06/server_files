#!/bin/sh

if [ -z $DOMAIN ]; then
    echo "==== No DOMAIN provided, running in HTTP mode ===="
    exec nginx -g 'daemon off;'
fi

echo "==== Running in HTTPS mode for DOMAIN: $DOMAIN ===="

if [ ! -d "/etc/letsencrypt/live/${DOMAIN}" ]; then
    sed "s/\.\*/\.${DOMAIN}/g" /etc/nginx/conf.d/nginx.conf.template > /etc/nginx/conf.d/nginx.conf

    echo "==== Getting SSL certificate ===="
    nginx
    sleep 2

    certbot --nginx --non-interactive --agree-tos --email "$EMAIL" \
            --cert-name "$DOMAIN" \
            -d "deluge.${DOMAIN}" \
            -d "sonarr.${DOMAIN}" \
            -d "radarr.${DOMAIN}" \
            -d "prowlarr.${DOMAIN}" \
            -d "jellyfin.${DOMAIN}" \
            --redirect

    cat /etc/nginx/conf.d/nginx.conf
    nginx -s quit
    sleep 1
fi

(
    while true; do
        sleep 12h
        echo "==== Renew certificates if needed ===="
        certbot renew --quiet
        nginx -s reload
    done
) &

exec nginx -g 'daemon off;'
