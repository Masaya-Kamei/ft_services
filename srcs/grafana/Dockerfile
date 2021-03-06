FROM	alpine:3.13.1

RUN		set -ex; \
		apk update; \
		apk add --no-cache vim wget supervisor; \
		mkdir /var/log/supervisord; \
		rm -rf /var/cache/apk/*

WORKDIR /tmp
RUN     set -ex; \
        wget https://dl.grafana.com/oss/release/grafana-7.4.1.linux-amd64.tar.gz; \
        tar -zxvf grafana-7.4.1.linux-amd64.tar.gz; \
        mv grafana-7.4.1 grafana; \
        rm grafana-7.4.1.linux-amd64.tar.gz; \
		mkdir /lib64; \
		ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2; \
		cp grafana/bin/grafana-server /usr/bin/; \
		sed -i -e 's/"search": false/"search": true/' /tmp/grafana/public/dashboards/home.json

WORKDIR /
COPY	./srcs/dashboards.yaml /tmp/grafana/conf/provisioning/dashboards/
COPY	./srcs/dashboards/* /tmp/grafana/data/dashboards/
COPY	./srcs/datasources.yaml /tmp/grafana/conf/provisioning/datasources/
COPY	./srcs/grafana.ini /tmp/grafana/conf/defaults.ini
COPY	./srcs/supervisord.conf /etc/
COPY	./srcs/healthcheck.sh /usr/bin/
RUN		set -ex; \
        chmod +r /tmp/grafana/conf/provisioning/dashboards/dashboards.yaml; \
        chmod +r /tmp/grafana/data/dashboards/*; \
        chmod +r /tmp/grafana/conf/provisioning/datasources/datasources.yaml; \
        chmod +r /tmp/grafana/conf/defaults.ini; \
        chmod +r /etc/supervisord.conf; \
		chmod +x /usr/bin/healthcheck.sh

ENTRYPOINT	["supervisord", "-c", "/etc/supervisord.conf"]
