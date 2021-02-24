#!/bin/ash

# WP_CONF_PATH=/var/www/html/wordpress
# envsubst '$${MYSQLUSER_PASS}' < ${WP_CONF_PATH}/wp-config.php.tmpl > ${WP_CONF_PATH}/wp-config.php

supervisord -c /etc/supervisord.conf
