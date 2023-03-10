#!/bin/ash

set -ex

if [ ! -d /data/mysql ]; then
	# mariadb を起動しようとすると実行するよう言われる、/var/lib/mysql にファイル群が作成される
	/etc/init.d/mariadb setup
	# 初期ファイル群を、dbデータの保存先にコピー
	cp -prf /var/lib/mysql /data/
	# # dbデータが保存されるディレクトリは、mysql mysql:mysql でないといけない
	chown -R mysql:mysql /data/mysql
	rc-service mariadb start
	MYSQL_PROCESS="/usr/bin/mariadbd --basedir=/usr --datadir=/data/mysql"
    while [ `ps | grep "${MYSQL_PROCESS}" | grep -v grep | wc -l` = 0 ]
    do
        sleep 0.1
    done
	# ALL PRIVILEGES -> 管理者権限を与える
	mysql -u root <<- EOSQL
		CREATE DATABASE wordpress_db;
		CREATE USER 'mysqluser'@'%' identified by '${MYSQLUSER_PASS}';
		GRANT ALL PRIVILEGES ON wordpress_db.* TO 'mysqluser'@'%';
	EOSQL
	rc-service mariadb stop
fi

supervisord -c /etc/supervisord.conf
