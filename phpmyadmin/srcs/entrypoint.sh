#!/bin/ash

rc-service php-fpm7 start
rc-service nginx start

tail -f /var/log/nginx/server_access.log
#exec "$@"
