#!/bin/ash

PROCESSES='grafana'

for PROCESS in ${PROCESSES}; do
	count=`ps | grep ${PROCESS} | grep -v grep | wc -l`
	if [ $count = 0 ]; then
		exit 1
	fi
done
