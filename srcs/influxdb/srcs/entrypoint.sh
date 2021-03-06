#!/bin/ash

set -ex

if [ ! -d /data/influxdb ]; then
	mkdir /data/influxdb
	chown -R influxdb:influxdb /data/influxdb
	sed -i -r 's/(auth-enabled = )true/# \1false/' /etc/influxdb.conf
	rc-service influxdb start
	INFLUXDB_PROCESS="/usr/sbin/influxd -config /etc/influxdb.conf"
    while [ `ps | grep "${INFLUXDB_PROCESS}" | grep -v grep | wc -l` = 0 ]
    do
        sleep 0.1
    done
	influx <<- EOSQL
		CREATE DATABASE influxname;
		CREATE USER influxuser WITH PASSWORD '${INFLUXUSER_PASS}' WITH ALL PRIVILEGES
	EOSQL
	rc-service influxdb stop
	sed -i -r 's/# (auth-enabled = )false/\1true/' /etc/influxdb.conf
fi

supervisord -c /etc/supervisord.conf
