#!/bin/ash

rc-service nginx start
rc-service sshd start

telegraf --config /home/telegraf/etc/telegraf/telegraf.conf
