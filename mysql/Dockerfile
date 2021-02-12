FROM	alpine:latest

RUN		set -ex; \
		apk update; \
		apk add --no-cache \
			vim openrc \
			mariadb mariadb-client; \
		rm -rf /var/cache/apk/*

# RUN		sed -i 's/#rc_sys=""/rc_sys="lxc"/g' /etc/rc.conf; \
# 		echo 'rc_provide="loopback net"' >> /etc/rc.conf; \
# 		sed -i 's/^#\(rc_logger="YES"\)$/\1/' /etc/rc.conf; \
# 		sed -i '/tty/d' /etc/inittab; \
# 		sed -i 's/hostname $opts/# hostname $opts/g' /etc/init.d/hostname; \
# 		sed -i 's/mount -t tmpfs/# mount -t tmpfs/g' /lib/rc/sh/init.sh; \
# 		sed -i 's/cgroup_add_service /# cgroup_add_service /g' /lib/rc/sh/openrc-run.sh; \
# 		mkdir /run/openrc; \
# 		touch /run/openrc/softlevel; \
# 		rc-status; \
# 		/etc/init.d/mariadb setup

RUN		set -ex; \
		sed -i -e '275 s/cgroup_add_service/#cgroup_add_service/' /lib/rc/sh/openrc-run.sh; \
		mkdir /run/openrc; \
 		touch /run/openrc/softlevel; \
 		rc-status; \
		/etc/init.d/mariadb setup

RUN		set -ex; \
		rc-service mariadb start; \
		echo "CREATE DATABASE dbname;" | mysql -u root; \
		echo "CREATE USER 'dbuser'@'%' identified by 'dbpassword';" | mysql -u root; \
		echo "GRANT ALL PRIVILEGES ON dbname.* TO 'dbuser'@'%';" | mysql -u root; \
		echo "FLUSH PRIVILEGES;" | mysql -u root; \
		rc-service mariadb stop

COPY    ./srcs/my.cnf /etc/my.cnf
COPY	./srcs/entrypoint.sh /usr/bin/
RUN		chmod +r /etc/my.cnf; \
		chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT	["sh", "/usr/bin/entrypoint.sh"]
