FROM	alpine:3.13.1

RUN	set -ex; \
	apk update; \
	apk add --no-cache \
		vim openrc nginx wget unzip  \
		php7 php7-mbstring php7-gd php7-iconv php7-session\
		php7-fpm php7-mysqli php7-json; \
	rm -rf /var/cache/apk/*

RUN     set -ex; \
        sed -i -e '275 s/cgroup_add_service/#cgroup_add_service/' /lib/rc/sh/openrc-run.sh; \
        mkdir /run/openrc; \
        touch /run/openrc/softlevel; \
        rc-status

WORKDIR /var/www/html
RUN     set -ex; \
        wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.zip; \
        unzip phpMyAdmin-5.0.4-all-languages.zip; \
        rm phpMyAdmin-5.0.4-all-languages.zip; \
        mv phpMyAdmin-5.0.4-all-languages phpmyadmin

WORKDIR /
COPY	./srcs/nginx.conf /etc/nginx/conf.d/default.conf
COPY	./srcs/php-fpm.conf /etc/php7/php-fpm.d/www.conf
COPY	./srcs/config.inc.php /var/www/html/phpmyadmin/config.inc.php
# RUN		rm /var/www/html/phpmyadmin/config.sample.inc.php
COPY	./srcs/entrypoint.sh /usr/bin/
RUN		set -ex; \
		chmod +r /etc/nginx/conf.d/default.conf; \
		chmod +r /etc/php7/php-fpm.d/www.conf; \
		chmod +r /var/www/html/phpmyadmin/config.inc.php; \
		chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT     ["entrypoint.sh"]

