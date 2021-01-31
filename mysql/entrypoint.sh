#!/bin/ash

rc-service mariadb start

tail -f /dev/null
#exec "$@"
