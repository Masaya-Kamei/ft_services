#!/bin/ash

NGINX_CONF_PATH=/etc/nginx/conf.d
envsubst '$${SERVICE_IP}' < ${NGINX_CONF_PATH}/default.conf.tmpl > ${NGINX_CONF_PATH}/default.conf

TELEGRAF_CONF_PATH=/home/telegraf/etc/telegraf
envsubst '$${INFLUXUSER_PASS}' < ${TELEGRAF_CONF_PATH}/telegraf.conf.tmpl > ${TELEGRAF_CONF_PATH}/telegraf.conf

echo "nginxuser:${NGINXUSER_PASS}" | chpasswd

supervisord -c /etc/supervisord.conf
