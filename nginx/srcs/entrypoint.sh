#!/bin/ash

rc-service nginx start
#rc-service php-fpm7 start

tail -f /var/log/nginx/server_access.log
