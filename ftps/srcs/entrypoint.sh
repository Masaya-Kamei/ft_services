#!/bin/ash

FTP_CONF_PATH=/etc/vsftpd
envsubst '$${SERVICE_IP}' < ${FTP_CONF_PATH}/vsftpd.conf.tmpl > ${FTP_CONF_PATH}/vsftpd.conf

echo "ftpsuser:${FTPSUSER_PASS}" | chpasswd

supervisord -c /etc/supervisord.conf
