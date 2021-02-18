#!/bin/ash

rc-service php-fpm7 start
rc-service nginx start

tail -f /dev/null
