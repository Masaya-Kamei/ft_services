#!/bin/ash

PROCESSES='nginx sshd telegraf'

for PROCESS in ${PROCESSES}; do
	count=`ps | grep ${PROCESS} | grep -v grep | wc -l`
	if [ $count = 0 ]; then
		exit 1
	fi
done
