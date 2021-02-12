FROM	alpine:latest

RUN	set -ex; \
	apk update; \
	apk add --no-cache \
		vim openrc nginx openssh-server; \
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

# WORKDIR /etc/nginx
# RUN     openssl req -newkey rsa:4096 -x509 -sha256 \
#                 -days 365 -nodes -out server.crt -keyout server.key \
#                 -subj "/C=JP/ST=Tokyo/L=Minato-ku/O=42Tokyo/OU=August/CN=example.com"

WORKDIR /
# COPY    ../cert/server.crt /etc/nginx/server.crt
# COPY    ../cert/server.key /etc/nginx/server.key
COPY	./srcs/default.conf /etc/nginx/conf.d/default.conf
COPY	./srcs/entrypoint.sh /usr/bin/
RUN		set -ex; \
		chmod +r /etc/nginx/conf.d/default.conf; \
		chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT	["sh", "/usr/bin/entrypoint.sh"]
