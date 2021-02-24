#!/bin/ash

if [ ! -d /data/mysql ]; then
	/etc/init.d/mariadb setup
	cp -prf /var/lib/mysql /data/
	chown -R mysql:mysql /data/mysql
	rc-service mariadb start
	mysql -u root <<- EOSQL
		CREATE DATABASE mysqlname;
		CREATE USER 'mysqluser'@'%' identified by '${MYSQLUSER_PASS}';
		GRANT ALL PRIVILEGES ON mysqlname.* TO 'mysqluser'@'%';
	EOSQL
	rc-service mariadb stop
fi

supervisord -c /etc/supervisord.conf
