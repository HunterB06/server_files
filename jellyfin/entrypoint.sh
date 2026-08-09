#! /bin/sh

umask 002

chown -R ${JELLYFIN_UID}:$GID /config

echo "======================== RUNNING JELLYFIN ================="
exec gosu jellyfin:${GID} /jellyfin/jellyfin
