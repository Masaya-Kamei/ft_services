FROM	alpine:latest

RUN	set -ex; \
	apk update; \
	apk add --no-cache \
		vim openrc vsftpd; \
	rm -rf /var/cache/apk/*

RUN     set -ex; \
        sed -i -e '275 s/cgroup_add_service/#cgroup_add_service/' /lib/rc/sh/openrc-run.sh; \
        mkdir /run/openrc; \
        touch /run/openrc/softlevel; \
        rc-status

RUN     set -ex; \
        adduser ftpuser -D; \
        echo 'ftpuser:ftppass' | chpasswd; \
        echo ftpuser > /etc/vsftpd/user_list; \
        touch /etc/vsftpd/chroot_list; \
        mkdir /etc/vsftpd/chroot_user_conf; \
        echo local_root=/tmp/ftpuser > /etc/vsftpd/chroot_user_conf/ftpuser; \
        mkdir /tmp/ftpuser; \
        mkdir /tmp/ftpuser/ftp_root; \
        cp /etc/passwd /tmp/ftpuser/ftp_root; \
        chown ftpuser:ftpuser /tmp/ftpuser/ftp_root

WORKDIR /
COPY	./srcs/vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY	./srcs/entrypoint.sh /usr/bin/
RUN	set -ex; \
	chmod +r /etc/vsftpd/vsftpd.conf; \ 
	chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT	["sh", "/usr/bin/entrypoint.sh"]
