FROM	alpine:3.13.1

RUN		set -ex; \
		apk update; \
		apk add --no-cache vim openrc nginx openssh-server; \
		rm -rf /var/cache/apk/*

RUN     set -ex; \
        sed -i -e '275 s/cgroup_add_service/#cgroup_add_service/' /lib/rc/sh/openrc-run.sh; \
        mkdir /run/openrc; \
        touch /run/openrc/softlevel; \
        rc-status

RUN     set -ex; \
        adduser user42 -D; \
        echo 'user42:user42' | chpasswd; \
        sed -i -e 's/#\(PasswordAuthentication yes\)/\1/g' /etc/ssh/sshd_config

WORKDIR /home
RUN     set -ex; \
        wget https://dl.influxdata.com/telegraf/releases/telegraf-1.17.2_linux_amd64.tar.gz; \
        tar -xvzf telegraf-1.17.2_linux_amd64.tar.gz; \
		mv telegraf-1.17.2 telegraf; \
		rm telegraf-1.17.2_linux_amd64.tar.gz; \
		mkdir /lib64; \
		ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2; \
		cp telegraf/usr/bin/telegraf /usr/bin/telegraf

WORKDIR /
COPY	./srcs/nginx.conf /etc/nginx/conf.d/default.conf
COPY	./srcs/telegraf.conf /home/telegraf/etc/telegraf/telegraf.conf
COPY	./srcs/entrypoint.sh /usr/bin/
RUN		set -ex; \
		chmod +r /etc/nginx/conf.d/default.conf; \
		chmod +r /home/telegraf/etc/telegraf/telegraf.conf; \
		chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT	["entrypoint.sh"]
