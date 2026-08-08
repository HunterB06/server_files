#! /bin/sh

stop_services()
{
    echo "Stopping services"
    kill -TERM "$DELUGE_WEB_PID" "$DELUGED_PID"

    wait "$DELUGED_PID"
    wait "$DELUGE_WEB_PID"

    echo "Services stopped"
    exit 0
}

trap 'stop_services' INT TERM

umask 002

chown -R ${DELUGE_UID}:${DELUGE_UID} /home/deluge/.config
gosu deluge mkdir -p /data/deluge
gosu deluge:deluge deluged -d -L info &
DELUGED_PID=$!

gosu deluge:deluge deluge-web -d &
DELUGE_WEB_PID=$!

wait "$DELUGED_PID" "$DELUGE_WEB_PID"
