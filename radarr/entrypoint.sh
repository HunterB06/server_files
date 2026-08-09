#! /bin/sh
set -e

umask 002

chown -R ${RADARR_UID}:${GID} /home/radarr/.config
gosu radarr:${GID} mkdir -p /data/radarr
exec gosu radarr:${GID} /opt/Radarr/Radarr -nobrowser -data=/home/radarr/.config/radarr
