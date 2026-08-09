#! /bin/sh
set -e

umask 002

chown -R ${SONARR_UID}:${GID} /home/sonarr/.config
gosu sonarr:${GID} mkdir -p /data/sonarr
exec gosu sonarr:${GID} /opt/Sonarr/Sonarr -nobrowser -data=/home/sonarr/.config/sonarr
