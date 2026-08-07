#! /bin/sh
set -e

umask 002
touch /data/toto
ls -l /data
