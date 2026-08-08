#! /bin/sh

umask 002

chown -R ${JELLYFIN_UID}:${JELLYFIN_UID} /config
echo "======================== RUNNING JELLYFIN ================="
exec gosu jellyfin /jellyfin/jellyfin
