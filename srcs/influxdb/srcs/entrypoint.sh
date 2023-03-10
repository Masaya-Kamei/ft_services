#!/bin/ash

set -ex

if [ ! -d /data/influxdb ]; then
	# dbデータが保存されるディレクトリはinfluxdb influxdb:influxdb である必要がある
	mkdir /data/influxdb
	chown -R influxdb:influxdb /data/influxdb
	# 匿名ユーザでのログインを有効にする
	sed -i -r 's/(auth-enabled = )true/# \1false/' /etc/influxdb.conf
	# rc-service influxdb start —> 	指定したディレクトリにファイル群が作成される
	#								インストールしたときではない
	rc-service influxdb start
	# 上記のコマンド終了後でもinfluxdbが起動していないことがあるので、
	# 起動するまで待機
	INFLUXDB_PROCESS="/usr/sbin/influxd -config /etc/influxdb.conf"
    while [ `ps | grep "${INFLUXDB_PROCESS}" | grep -v grep | wc -l` = 0 ]
    do
        sleep 0.1
    done
	# WITH ALL PRIVILEGES :adminユーザ
	influx <<- EOSQL
		CREATE DATABASE influxname;
		CREATE USER influxuser WITH PASSWORD '${INFLUXUSER_PASS}' WITH ALL PRIVILEGES
	EOSQL
	rc-service influxdb stop
	# 匿名ユーザでのログインを無効にする
	sed -i -r 's/# (auth-enabled = )false/\1true/' /etc/influxdb.conf
fi

supervisord -c /etc/supervisord.conf
