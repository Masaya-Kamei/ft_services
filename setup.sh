#!/bin/sh

set -ex
cd srcs

OS=`uname`
if [ ${OS} = "Linux" ]; then
	minikube start
else
	minikube start --driver=hyperkit
fi

SERVICE_IP=`minikube ip | sed -r 's/192\.168\.([0-9]{1,3})\.[0-9]{1,3}/192.168.\1.100/'`
export SERVICE_IP
envsubst '$$SERVICE_IP' < config/metallb-config.yaml.tmpl > config/metallb-config.yaml
envsubst '$$SERVICE_IP' < config/service-cm.yaml.tmpl > config/service-cm.yaml

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
kubectl apply -f config/metallb-config.yaml

kubectl apply -f config/service-cm.yaml
kubectl apply -f config/service-secret.yaml

openssl req -newkey rsa:4096 -x509 -sha256 \
    -days 365 -nodes -out cert/server.crt -keyout cert/server.key \
    -subj "/C=JP/ST=Tokyo/L=Minato-ku/O=42Tokyo/OU=August/CN=example.com"
kubectl create secret generic cert-secret --from-file=cert/server.crt --from-file=cert/server.key

eval $(minikube docker-env)

SERVICES=(mysql influxdb ftps phpmyadmin wordpress grafana nginx)
for S in ${SERVICES[@]}; do
	docker build -t mkamei/${S} ${S}/
	kubectl apply -f ${S}/${S}.yaml
done
