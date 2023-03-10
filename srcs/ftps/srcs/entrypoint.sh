#!/bin/ash

set -ex

# sed
# -i :ファイルを直接編集、-r :拡張正規表現 (基本正規表現より一般的)
# () は \1 で取り出せる、[0-9]{1,3} -> 0~9の1~3桁
# 192.168.(0~9の1~3桁).(0~9の1~3桁) ー＞ ${SERVICE_IP}
sed -i -r "s/192\.168\.[0-9]{1,3}\.[0-9]{1,3}/${SERVICE_IP}/g" /etc/vsftpd/vsftpd.conf
# ftpsuserのパスワードを変更
echo "ftpsuser:${FTPSUSER_PASS}" | chpasswd

supervisord -c /etc/supervisord.conf
