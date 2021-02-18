FROM	alpine:3.13.1

RUN		set -ex; \
		apk update; \
		apk add --no-cache vim openrc mariadb mariadb-client; \
		rm -rf /var/cache/apk/*

RUN		set -ex; \
		sed -i -e '275 s/cgroup_add_service/#cgroup_add_service/' /lib/rc/sh/openrc-run.sh; \
		mkdir /run/openrc; \
 		touch /run/openrc/softlevel; \
		/etc/init.d/mariadb setup; \
 		rc-status

RUN		set -ex; \
		rc-service mariadb start; \
		echo "CREATE DATABASE dbname;" | mysql -u root; \
		echo "CREATE USER 'dbuser'@'%' identified by 'dbpassword';" | mysql -u root; \
		echo "GRANT ALL PRIVILEGES ON dbname.* TO 'dbuser'@'%';" | mysql -u root
RUN		rc-service mariadb stop

COPY    ./srcs/mysql.cnf /etc/my.cnf
COPY	./srcs/entrypoint.sh /usr/bin/
RUN		set -ex; \
		chmod +r /etc/my.cnf; \
		chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT     ["entrypoint.sh"]
