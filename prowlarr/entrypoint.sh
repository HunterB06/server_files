#! /bin/sh
set -e

umask 002

chown -R ${PROWLARR_UID}:${PROWLARR_UID} /home/prowlarr/.config

exec gosu prowlarr /opt/Prowlarr/Prowlarr -nobrowser -data=/home/prowlarr/.config/prowlarr
