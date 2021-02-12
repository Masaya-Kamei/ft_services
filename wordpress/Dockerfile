FROM	alpine:latest

RUN		set -ex; \
		apk update; \
		apk add --no-cache \
			vim openrc wget nginx \
			php7 php7-mbstring php7-gd php7-iconv \
			php7-fpm php7-mysqli php7-json; \
		rm -rf /var/cache/apk/*

RUN     set -ex; \
		sed -i -e '275 s/cgroup_add_service/#cgroup_add_service/' /lib/rc/sh/openrc-run.sh; \
		mkdir /run/openrc; \
        touch /run/openrc/softlevel; \
        rc-status

WORKDIR	/var/www/html/
RUN		set -ex; \
		wget https://wordpress.org/latest.tar.gz; \
		tar -xvzf latest.tar.gz; \
		rm latest.tar.gz; \
		chown -R nginx:nginx /var/www/html/wordpress

WORKDIR /
COPY	./srcs/default.conf /etc/nginx/conf.d/default.conf
COPY	./srcs/wp-config.php /var/www/html/wordpress/
COPY	./srcs/www.conf /etc/php7/php-fpm.d/www.conf
COPY	./srcs/entrypoint.sh /usr/bin/
RUN		set -ex; \
		chmod +r /etc/nginx/conf.d/default.conf; \
		chmod +r /var/www/html/wordpress/wp-config.php; \
		chmod +r /etc/php7/php-fpm.d/www.conf; \
		chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT	["sh", "/usr/bin/entrypoint.sh"]
