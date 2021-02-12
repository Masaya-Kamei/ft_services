kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
kubectl apply -f metallb/metallb-config.yaml

openssl req -newkey rsa:4096 -x509 -sha256 \
    -days 365 -nodes -out cert/server.crt -keyout cert/server.key \
    -subj "/C=JP/ST=Tokyo/L=Minato-ku/O=42Tokyo/OU=August/CN=example.com"

kubectl create secret generic secret-data --from-file=cert/server.crt --from-file=cert/server.key
kubectl apply -f mysql/pv01.yaml
kubectl apply -f mysql/pv-claim.yaml

eval $(minikube docker-env)
docker build -t mkamei/nginx nginx/
docker build -t mkamei/mysql mysql/
docker build -t mkamei/wordpress wordpress/
docker build -t mkamei/phpmyadmin phpmyadmin/

kubectl apply -f nginx/nginx.yaml
kubectl apply -f mysql/mysql.yaml
kubectl apply -f wordpress/wordpress.yaml
kubectl apply -f phpmyadmin/phpmyadmin.yaml

