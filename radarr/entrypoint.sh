#! /bin/sh
set -e

umask 002

chown -R ${RADARR_UID}:${RADARR_UID} /home/radarr/.config
gosu radarr mkdir -p /data/radarr
exec gosu radarr /opt/Radarr/Radarr -nobrowser -data=/home/radarr/.config/radarr
