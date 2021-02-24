set -ex

OS=`uname`
if [ ${OS} = "Linux" ]; then
	minikube start
else
	minikube start --driver=virtualbox
fi

SERVICE_IP=`minikube ip | sed -r 's/192\.168\.([0-9]{1,3})\.[0-9]{1,3}/192.168.\1.100/'`
sed -i -r "s/192\.168\.[0-9]{1,3}\.[0-9]{1,3}/${SERVICE_IP}/g" metallb/metallb-config.yaml
sed -i -r "s/SERVICE_IP:.*/SERVICE_IP: ${SERVICE_IP}/" service-cm.yaml

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
kubectl apply -f metallb/metallb-config.yaml

openssl req -newkey rsa:4096 -x509 -sha256 \
    -days 365 -nodes -out cert/server.crt -keyout cert/server.key \
    -subj "/C=JP/ST=Tokyo/L=Minato-ku/O=42Tokyo/OU=August/CN=example.com"
kubectl create secret generic cert-secret --from-file=cert/server.crt --from-file=cert/server.key

kubectl apply -f service-cm.yaml
kubectl apply -f service-secret.yaml

eval $(minikube docker-env)

SERVICES='mysql influxdb ftps wordpress phpmyadmin grafana nginx'
for S in ${SERVICES}; do
	docker build -t mkamei/${S} ${S}/
	kubectl apply -f ${S}/${S}.yaml
done
