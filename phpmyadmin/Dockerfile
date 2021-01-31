FROM	alpine:latest

RUN		set -ex; \
		apk update; \
		apk add --no-cache \
			wget vim unzip openssl \
			nginx \
			php7 php7-mbstring php7-gd php7-iconv php7-session\
			php7-fpm php7-mysqli php7-json certbot openrc; \
		mkdir /run/nginx/; \
		rm -rf /var/cache/apk/*

RUN     sed -i 's/#rc_sys=""/rc_sys="lxc"/g' /etc/rc.conf; \
        echo 'rc_provide="loopback net"' >> /etc/rc.conf; \
        sed -i 's/^#\(rc_logger="YES"\)$/\1/' /etc/rc.conf; \
        sed -i '/tty/d' /etc/inittab; \
        sed -i 's/hostname $opts/# hostname $opts/g' /etc/init.d/hostname; \
        sed -i 's/mount -t tmpfs/# mount -t tmpfs/g' /lib/rc/sh/init.sh; \
        sed -i 's/cgroup_add_service /# cgroup_add_service /g' /lib/rc/sh/openrc-run.sh; \
        mkdir /run/openrc; \
        touch /run/openrc/softlevel; \
        rc-status

WORKDIR /var/www/html
RUN     set -ex; \
        wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.zip; \
        unzip phpMyAdmin-5.0.4-all-languages.zip; \
        rm phpMyAdmin-5.0.4-all-languages.zip; \
        mv phpMyAdmin-5.0.4-all-languages phpmyadmin

#WORKDIR /etc/nginx
#RUN		openssl req -newkey rsa:4096 \
#			-x509 \
#			-sha256 \
#			-days 3650 \
#			-nodes \
#			-out server.crt \
#			-keyout server.key \
#			-subj "/C=JP/ST=Tokyo/L=Minato-ku/O=42Tokyo/OU=August/CN=example.com"

WORKDIR /
COPY	./srcs/default.conf /etc/nginx/conf.d/default.conf
COPY	./srcs/www.conf /etc/php7/php-fpm.d/www.conf
COPY	./srcs/config.inc.php /var/www/html/phpmyadmin/config.inc.php
RUN		rm /var/www/html/phpmyadmin/config.sample.inc.php
COPY	./srcs/entrypoint.sh /usr/bin/
RUN		set -ex; \
		chmod +r /etc/nginx/conf.d/default.conf; \
		chmod +r /etc/php7/php-fpm.d/www.conf; \
		chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT	["sh", "/usr/bin/entrypoint.sh"]
