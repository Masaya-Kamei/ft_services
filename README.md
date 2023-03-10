# 42 ft_services

## 概要

kubernetesを使って複数のマイクロサービスを立ち上げる
- Dockerイメージはすべて`Alpine Linux`を使用
- minikubeで単一ノードのKubernetes環境を構築
- MetalLBでPodにアクセスを振り分ける
- k8s のPod, Deployment, Serviceなどを使用
- LEMP環境, phpmyadmin, FTPサーバーを構築
- Telegraf, InfluxDB, Grafanaでメトリクスを収集, 可視化

## 各サービスへのアクセス

- nginx
  - `https://${SERVICE_IP}` -> index.html
  - `https://${SERVICE_IP}/wordpress` -> wordpress へリダイレクト
  - `https://${SERVICE_IP}/phpmyadmin` -> phpmyadmin へリバースプロキシ
  - `ssh nginxuser@${SERVICE_IP}` (Password: `nginxpass`)
- wordpress
  - `https://${SERVICE_IP}:5050` (User: `wpuser`, Password: `wppass`)
- phpmyadmin
  - `https://${SERVICE_IP}:5000` (User: `mysqluser`, Password: `mysqlpass`)
- grafana
  - `https://${SERVICE_IP}:3000` (User: `grafanauser`, Password: `grafanapass`)
- ftps
  - `lftp ftpsuser@${SERVICE_IP}` (Password: `ftpspass`)
  - 対話モード コマンド
    ```
    set ssl:verify-certificate no
    cd ftpsuser
    ls
    !ls
    get hello.txt
    put [file名]
    ```

## キーワード

`kubernetes`,`docker`,`minikube`,`MetalLB`,`alpine`,`nginx`,`wordpress`,`mysql`,`phpmyadmin`,`ftps`,`Telegraf`,`InfluxDB`,`Grafana`
