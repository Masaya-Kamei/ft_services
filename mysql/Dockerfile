FROM	alpine:3.13.1

RUN		set -ex; \
		apk update; \
		apk add --no-cache vim openrc mariadb mariadb-client supervisor; \
		mkdir /var/log/supervisord; \
		rm -rf /var/cache/apk/*

RUN		set -ex; \
		sed -i -e '275 s/cgroup_add_service/#cgroup_add_service/' /lib/rc/sh/openrc-run.sh; \
		mkdir /run/openrc; \
 		touch /run/openrc/softlevel; \
 		rc-status

COPY    ./srcs/mysql.cnf /etc/my.cnf
COPY    ./srcs/supervisord.conf /etc/
COPY	./srcs/healthcheck.sh /usr/bin/
COPY	./srcs/entrypoint.sh /usr/bin/
RUN		set -ex; \
		chmod +r /etc/my.cnf; \
		chmod +r /etc/supervisord.conf; \
		chmod +x /usr/bin/healthcheck.sh; \
		chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT	["entrypoint.sh"]
