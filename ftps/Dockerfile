FROM	alpine:3.13.1

RUN		set -ex; \
		apk update; \
		apk add --no-cache vim openrc vsftpd supervisor gettext; \
		mkdir /var/log/supervisord; \
		rm -rf /var/cache/apk/*

RUN     set -ex; \
        sed -i -e '275 s/cgroup_add_service/#cgroup_add_service/' /lib/rc/sh/openrc-run.sh; \
        mkdir /run/openrc; \
        touch /run/openrc/softlevel; \
        rc-status

RUN     set -ex; \
        adduser ftpsuser -D; \
        echo ftpsuser > /etc/vsftpd/user_list; \
        touch /etc/vsftpd/chroot_list; \
        mkdir /etc/vsftpd/user_conf; \
        echo local_root=/home > /etc/vsftpd/user_conf/ftpsuser; \
        echo -e "Hello\nHello\nHello" > /home/ftpsuser/hello.txt

COPY	./srcs/vsftpd.conf.tmpl /etc/vsftpd/vsftpd.conf.tmpl
COPY	./srcs/supervisord.conf /etc/
COPY	./srcs/healthcheck.sh /usr/bin/
COPY	./srcs/entrypoint.sh /usr/bin/
RUN		set -ex; \
		chmod +r /etc/vsftpd/vsftpd.conf.tmpl; \
		chmod +r /etc/supervisord.conf; \
		chmod +x /usr/bin/healthcheck.sh; \
		chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT	["entrypoint.sh"]
