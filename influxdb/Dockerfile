FROM	alpine:3.13.1

RUN		set -ex; \
		apk update; \
		apk add --no-cache vim openrc influxdb; \
		rm -rf /var/cache/apk/*

RUN		set -ex; \
		sed -i -e '275 s/cgroup_add_service/#cgroup_add_service/' /lib/rc/sh/openrc-run.sh; \
		mkdir /run/openrc; \
 		touch /run/openrc/softlevel; \
 		rc-status

RUN		set -ex; \
		rc-service influxdb start; \
		echo "CREATE DATABASE dbname; CREATE USER dbuser WITH PASSWORD 'dbpassword' WITH ALL PRIVILEGES;" | influx
RUN		rc-service influxdb stop

COPY	./srcs/influxdb.conf /etc/influxdb.conf
COPY	./srcs/entrypoint.sh /usr/bin/
RUN		set -ex; \
		chmod +r /etc/influxdb.conf; \
		chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT	["entrypoint.sh"]
