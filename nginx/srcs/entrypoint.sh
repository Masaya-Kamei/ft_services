#!/bin/ash

rc-service nginx start
rc-service sshd start

tail -f /var/log/nginx/server_access.log
