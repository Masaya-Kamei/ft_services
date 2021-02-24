
kubectl delete -f mysql/mysql.yaml
kubectl delete -f influxdb/influxdb.yaml
kubectl delete -f ftps/ftps.yaml
kubectl delete -f wordpress/wordpress.yaml
kubectl delete -f phpmyadmin/phpmyadmin.yaml
kubectl delete -f grafana/grafana.yaml
kubectl delete -f nginx/nginx.yaml

set -ex

eval $(minikube docker-env)

if [ "$1" = "no" ]; then
	echo "Noooooooooooooooooooooooooooooooooooooo cache"
	docker build -t mkamei/mysql mysql/ --no-cache
	docker build -t mkamei/influxdb influxdb/ --no-cache
	docker build -t mkamei/ftps ftps/ --no-cache
	docker build -t mkamei/wordpress wordpress/ --no-cache
	docker build -t mkamei/phpmyadmin phpmyadmin/ --no-cache
	docker build -t mkamei/grafana grafana/ --no-cache
	docker build -t mkamei/nginx nginx/ --no-cache
else
	echo "Ussssssssssssssssssssssssssssssssssssing cache"
	docker build -t mkamei/mysql mysql/
	docker build -t mkamei/influxdb influxdb/
	docker build -t mkamei/ftps ftps/ --no-cache
	docker build -t mkamei/wordpress wordpress/
	docker build -t mkamei/phpmyadmin phpmyadmin/
	docker build -t mkamei/grafana grafana/
	docker build -t mkamei/nginx nginx/
fi

kubectl apply -f mysql/mysql.yaml
kubectl apply -f influxdb/influxdb.yaml
kubectl apply -f ftps/ftps.yaml
kubectl apply -f wordpress/wordpress.yaml
kubectl apply -f phpmyadmin/phpmyadmin.yaml
kubectl apply -f grafana/grafana.yaml
kubectl apply -f nginx/nginx.yaml

kubectl get pod