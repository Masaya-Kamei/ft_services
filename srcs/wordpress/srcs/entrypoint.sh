#!/bin/ash

set -ex

# wordpress がインストールされているかをチェック
if ! $(wp core is-installed --path=/var/www/html/wordpress); then
	rc-service nginx start
	NGINX_PROCESS="/usr/sbin/nginx -c /etc/nginx/nginx.conf"
    while [ `ps | grep "${NGINX_PROCESS}" | grep -v grep | wc -l` = 0 ]
    do
        sleep 0.1
    done
	# wordpressをインストール
	wp core install --path=/var/www/html/wordpress --url=https://${SERVICE_IP}:5050 --title=wptitle --admin_user=wpuser --admin_password=${WPUSER_PASS} --admin_email=wpemail@example.com --skip-email
	# meta情報のウィジェットを、wordpressの閲覧ページに配置
	wp widget add meta sidebar-1 2 --path=/var/www/html/wordpress
	# 権限がeditorの、ユーザを作成
	wp user create wpuser2 --user_pass=wppass2 wpemail2@example.com --role=editor --path=/var/www/html/wordpress
	wp user create wpuser3 --user_pass=wppass3 wpemail3@example.com --role=author --path=/var/www/html/wordpress
	rc-service nginx stop
fi

supervisord -c /etc/supervisord.conf
