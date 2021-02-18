set -ex

kubectl delete -f "$1"/"$1".yaml

if [ "$2" = "no" ]; then
	echo "Nooooooooooooooooooo cache"
	docker build -t mkamei/"$1" "$1"/ --no-cache
else
	echo "uuuuuuuuuuuuuuuuusing cache"
	docker build -t mkamei/"$1" "$1"/
fi

kubectl apply -f "$1"/"$1".yaml

kubectl get pod
