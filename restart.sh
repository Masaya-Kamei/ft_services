kubectl delete -f nginx/nginx.yaml
kubectl delete -f mysql/mysql.yaml
kubectl delete -f wordpress/wordpress.yaml
kubectl delete -f phpmyadmin/phpmyadmin.yaml

docker build -t mkamei/nginx nginx/
docker build -t mkamei/mysql mysql/
docker build -t mkamei/wordpress wordpress/
docker build -t mkamei/phpmyadmin phpmyadmin/

kubectl apply -f nginx/nginx.yaml
kubectl apply -f mysql/mysql.yaml
kubectl apply -f wordpress/wordpress.yaml
kubectl apply -f phpmyadmin/phpmyadmin.yaml

