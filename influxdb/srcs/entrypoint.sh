#!/bin/ash

if [ ! -d /data/influxdb ]; then
  mkdir /data/influxdb
  cp -prf /var/lib/influxdb/* /data/influxdb/
  chown -R influxdb:influxdb /data/influxdb
fi

rc-service influxdb start

tail -f /dev/null
