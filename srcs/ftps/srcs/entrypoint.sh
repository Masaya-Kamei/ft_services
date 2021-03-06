#!/bin/ash

set -ex

sed -i -r "s/192\.168\.[0-9]{1,3}\.[0-9]{1,3}/${SERVICE_IP}/g" /etc/vsftpd/vsftpd.conf

echo "ftpsuser:${FTPSUSER_PASS}" | chpasswd

supervisord -c /etc/supervisord.conf
