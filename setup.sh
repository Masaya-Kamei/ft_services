#!/bin/zsh

set -ex
cd srcs

OS=`uname`
# Minikube の driver は 指定がない場合、以前使っていたドライバが使用される。
if [ ${OS} = "Linux" ]; then
	minikube start --driver=docker
else
	minikube start --driver=hyperkit
fi

SERVICE_IP=`minikube ip | sed -r 's/192\.168\.([0-9]{1,3})\.[0-9]{1,3}/192.168.\1.100/'`
export SERVICE_IP
envsubst '$$SERVICE_IP' < config/metallb-config.yaml.tmpl > config/metallb-config.yaml
envsubst '$$SERVICE_IP' < config/service-cm.yaml.tmpl > config/service-cm.yaml

# MetalLB :オンプレミスでもtype: LoadBalancerを扱えるようにする
# type: LoadBalancer -> サービスを外部に公開する
# AWSやGCP、Azureなどのパブリッククラウドのみで、オンプレミスでは利用できない
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.9/config/manifests/metallb-native.yaml
# MetalLBの設定ファイルを適用
kubectl apply -f config/metallb-config.yaml
# https://github.com/metallb/metallb/issues/1597
for i in {1..20}; do
    kubectl apply -f config/metallb-config.yaml && break
    sleep 5
    if [ $i -eq 20 ]; then
        echo "Failed to apply metallb config"
        exit 1
    fi
done

# configMap, secret :コンテナ内で使う環境変数を定義
# secretはデータを暗号化して保存してくれる
kubectl apply -f config/service-cm.yaml
kubectl apply -f config/service-secret.yaml

# オレオレ証明書を作成
openssl req -newkey rsa:4096 -x509 -sha256 \
    -days 365 -nodes -out cert/server.crt -keyout cert/server.key \
    -subj "/C=JP/ST=Tokyo/L=Minato-ku/O=42Tokyo/OU=August/CN=example.com"
# ファイルから、secretを作成
kubectl create secret generic cert-secret --from-file=cert/server.crt --from-file=cert/server.key

# MinikubeのVM内のDockerデーモンと通信しているホストのMac/LinuxマシンでDockerを使用可能になる
eval $(minikube docker-env)

# シェルの配列、for文
SERVICES=(mysql influxdb ftps phpmyadmin wordpress grafana nginx)
for S in ${SERVICES[@]}; do
	docker build -t mkamei/${S} ${S}/
	kubectl apply -f ${S}/${S}.yaml
done
