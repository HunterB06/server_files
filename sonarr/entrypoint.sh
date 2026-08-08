#! /bin/sh
set -e

umask 002

chown -R ${SONARR_UID}:${GID} /home/sonarr/.config

exec gosu sonarr:sonarr /opt/Sonarr/Sonarr -nobrowser -data=/home/sonarr/.config/sonarr
