FROM	alpine:3.13.1

RUN		set -ex; \
		apk update; \
		apk add --no-cache \
			openrc vim wget nginx nginx-mod-http-perl supervisor \
			php7 php7-mbstring php7-gd php7-iconv php7-fpm php7-mysqli php7-json php7-phar; \
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

# wp コマンドをインストール
# wp-cli :wordpress をコマンドラインで操作するツール
WORKDIR /
RUN		set -ex; \
		wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar; \
		chmod +x wp-cli.phar; \
		mv wp-cli.phar /usr/bin/wp

COPY	./srcs/server.conf /etc/nginx/conf.d/default.conf
COPY	./srcs/php-fpm.conf /etc/php7/php-fpm.d/www.conf
COPY	./srcs/wp-config.php /var/www/html/wordpress/
COPY	./srcs/supervisord.conf /etc/
COPY	./srcs/healthcheck.sh /usr/bin/
COPY	./srcs/entrypoint.sh /usr/bin/
RUN		set -ex; \
		# rc-service は環境変数を引き継がない、rc-service で使う環境変数を設定
		sed -i -r "s/#(rc_env_allow=)\".*\"/\1\"MYSQLUSER_PASS\"/" /etc/rc.conf; \
		# nginx の perl_module を使用して、環境変数をnginxで展開する
		# /i 指定した行の上に挿入する
		# /a 指定した行の下に挿入する
		sed -i -r "/http \{/i env MYSQLUSER_PASS;\n" /etc/nginx/nginx.conf; \
		sed -i -r "/http \{/a \        perl_set \$MYSQLUSER_PASS \'sub { return \$ENV{\"MYSQLUSER_PASS\"}; }\';\n" /etc/nginx/nginx.conf; \
		chmod +r /etc/nginx/conf.d/default.conf; \
		chmod +r /etc/php7/php-fpm.d/www.conf; \
		chmod +r /var/www/html/wordpress/wp-config.php; \
		chmod +r /etc/supervisord.conf; \
		chmod +x /usr/bin/healthcheck.sh; \
		chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT	["entrypoint.sh"]
