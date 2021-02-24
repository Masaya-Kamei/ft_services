#!/bin/ash

GRAFANA_CONF_PATH=/home/grafana/conf
envsubst '$${GRAFANAUSER_PASS}' < ${GRAFANA_CONF_PATH}/defaults.ini.tmpl > ${GRAFANA_CONF_PATH}/defaults.ini

DATASOURCES_PATH=/home/grafana/conf/provisioning/datasources
envsubst '$${INFLUXUSER_PASS}' < ${DATASOURCES_PATH}/datasources.yaml.tmpl > ${DATASOURCES_PATH}/datasources.yaml

supervisord -c /etc/supervisord.conf
