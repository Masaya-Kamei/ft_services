#!/bin/ash

if [ ! -d /data/mysql ]; then
  mkdir /data/mysql
  cp -prf /var/lib/mysql/* /data/mysql/
fi

rc-service mariadb start

tail -f /dev/null
