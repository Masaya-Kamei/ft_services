# alpine
# 組み込み系でよく使われているBusyBoxとmuslをベースにしたLinuxディストリビューション
# 超軽量 (CentOS 約4GB, Ubuntu 約700MB, Alpine 約100MB)
FROM	alpine:3.13.1

RUN		set -ex; \
		apk update; \
		apk add --no-cache vim openrc vsftpd supervisor; \
		mkdir /var/log/supervisord; \
		rm -rf /var/cache/apk/*

RUN     set -ex; \
		# cgoup_add_service 関数はエラーが出るので、呼び出さない
        sed -i -e '275 s/cgroup_add_service/#cgroup_add_service/' /lib/rc/sh/openrc-run.sh; \
		# /run/openrc/softlevel を作成しないとエラー
        mkdir /run/openrc; \
        touch /run/openrc/softlevel; \
		# rc-status をしないと下記のエラーがでる
		# * WARNING: nginx is already starting
		# * ERROR: nginx stopped by something else
        rc-status

RUN     set -ex; \
        adduser ftpsuser -D; \
		# user_list :ログインできるユーザ、にftpsuserを追加
        echo ftpsuser > /etc/vsftpd/user_list; \
		# chroot_list :ホームディレクトリより上層へアクセスできるユーザ
        touch /etc/vsftpd/chroot_list; \
        mkdir /etc/vsftpd/user_conf; \
		# ftpsuserのログイン後のディレクトリを指定
		# local_root のディレクトリの所有者がftpsuserの場合、以下のエラーが発生
		# ls: 致命的エラー: SSL_read: wrong version number
		# 所有者がftpsuser 以外の場合put やget を実行すると、以下のエラーが発生
		# put: Access failed: 553 Could not create file. (setup.sh)
		# つまりftpsuserでログインした後、ftpsuserディレクトリに移動して作業する*
        echo local_root=/home > /etc/vsftpd/user_conf/ftpsuser; \
        echo -e "Hello\nHello\nHello" > /home/ftpsuser/hello.txt

COPY	./srcs/vsftpd.conf /etc/vsftpd/
COPY	./srcs/supervisord.conf /etc/
COPY	./srcs/healthcheck.sh /usr/bin/
COPY	./srcs/entrypoint.sh /usr/bin/
RUN		set -ex; \
		chmod +r /etc/vsftpd/vsftpd.conf; \
		chmod +r /etc/supervisord.conf; \
		chmod +x /usr/bin/healthcheck.sh; \
		chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT	["entrypoint.sh"]
