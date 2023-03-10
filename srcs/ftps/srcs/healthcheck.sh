#!/bin/ash

PROCESSES='vsftpd'

for PROCESS in ${PROCESSES}; do
	# USER が nginx の場合、healthcheck ができないので、awk コマンドを使用
	count=`ps | awk '{print $4}' | grep ${PROCESS} | grep -v grep | wc -l`
	if [ $count = 0 ]; then
		exit 1
	fi
done
