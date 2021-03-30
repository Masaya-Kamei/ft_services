#!/bin/ash

PROCESSES='influxd'

for PROCESS in ${PROCESSES}; do
	count=`ps | awk '{print $4}' | grep ${PROCESS} | grep -v grep | wc -l`
	if [ $count = 0 ]; then
		exit 1
	fi
done
