#! /bin/sh
set -e

umask 002

chown -R ${DELUGE_UID}:${GID} /home/deluge/.config
gosu deluge:deluge deluged
gosu deluge:deluge deluge-web -d
