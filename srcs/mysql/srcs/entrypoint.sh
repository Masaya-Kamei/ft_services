#!/bin/ash

set -ex

if [ ! -d /data/mysql ]; then
	/etc/init.d/mariadb setup
	cp -prf /var/lib/mysql /data/
	chown -R mysql:mysql /data/mysql
	rc-service mariadb start
	MYSQL_PROCESS="/usr/bin/mariadbd --basedir=/usr --datadir=/data/mysql"
    while [ `ps | grep "${MYSQL_PROCESS}" | grep -v grep | wc -l` = 0 ]
    do
        sleep 0.1
    done
	mysql -u root <<- EOSQL
		CREATE DATABASE wordpress_db;
		CREATE USER 'mysqluser'@'%' identified by '${MYSQLUSER_PASS}';
		GRANT ALL PRIVILEGES ON wordpress_db.* TO 'mysqluser'@'%';
	EOSQL
	rc-service mariadb stop
fi

supervisord -c /etc/supervisord.conf
