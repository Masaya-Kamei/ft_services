FROM	alpine:3.13.1

RUN		set -ex; \
		apk update; \
		apk add --no-cache \
			vim openrc wget nginx supervisor gettext \
			php7 php7-mbstring php7-gd php7-iconv \
			php7-fpm php7-mysqli php7-json; \
		mkdir /var/log/supervisord; \
		rm -rf /var/cache/apk/*

RUN     set -ex; \
		sed -i -e '275 s/cgroup_add_service/#cgroup_add_service/' /lib/rc/sh/openrc-run.sh; \
		mkdir /run/openrc; \
        touch /run/openrc/softlevel; \
        rc-status

WORKDIR	/var/www/html/
RUN		set -ex; \
		wget https://ja.wordpress.org/wordpress-5.6.1-ja.tar.gz; \
		tar -xvzf wordpress-5.6.1-ja.tar.gz; \
		rm wordpress-5.6.1-ja.tar.gz; \
		chown -R nginx:nginx /var/www/html/wordpress

WORKDIR /
COPY	./srcs/nginx.conf /etc/nginx/conf.d/default.conf
COPY	./srcs/php-fpm.conf /etc/php7/php-fpm.d/www.conf
COPY	./srcs/wp-config.php /var/www/html/wordpress/
COPY	./srcs/supervisord.conf /etc/
COPY	./srcs/healthcheck.sh /usr/bin/
COPY	./srcs/entrypoint.sh /usr/bin/
RUN		set -ex; \
		chmod +r /etc/nginx/conf.d/default.conf; \
		chmod +r /etc/php7/php-fpm.d/www.conf; \
		chmod +r /var/www/html/wordpress/wp-config.php; \
		chmod +r /etc/supervisord.conf; \
		chmod +x /usr/bin/healthcheck.sh; \
		chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT	["entrypoint.sh"]
