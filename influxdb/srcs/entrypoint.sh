#!/bin/ash

if [ ! -d /data/influxdb ]; then
	mkdir /data/influxdb
	chown -R influxdb:influxdb /data/influxdb
	rc-service influxdb start
	influx <<- EOSQL
		CREATE DATABASE influxname;
		CREATE USER influxuser WITH PASSWORD '${INFLUXUSER_PASS}' WITH ALL PRIVILEGES
	EOSQL
	rc-service influxdb stop
	sed -i -r 's/# (auth-enabled = )false/\1true/' /etc/influxdb.conf
fi

supervisord -c /etc/supervisord.conf
