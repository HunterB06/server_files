#! /bin/sh
set -e

umask 002

chown -R ${SONARR_UID}:${SONARR_UID} /home/sonarr/.config
gosu sonarr mkdir -p /data/sonarr
exec gosu sonarr /opt/Sonarr/Sonarr -nobrowser -data=/home/sonarr/.config/sonarr
