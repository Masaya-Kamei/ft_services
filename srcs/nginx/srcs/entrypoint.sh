#!/bin/ash

set -ex

sed -i -r "s/192\.168\.[0-9]{1,3}\.[0-9]{1,3}/${SERVICE_IP}/g" /var/www/index.html

echo "nginxuser:${NGINXUSER_PASS}" | chpasswd

supervisord -c /etc/supervisord.conf
