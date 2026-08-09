#! /bin/sh
set -e

umask 002

chown -R ${PROWLARR_UID}:${GID} /home/prowlarr/.config

exec gosu prowlarr:${GID} /opt/Prowlarr/Prowlarr -nobrowser -data=/home/prowlarr/.config/prowlarr
