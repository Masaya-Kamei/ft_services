FROM	alpine:3.13.1

RUN		set -ex; \
		apk update; \
		apk add --no-cache vim wget supervisor; \
		rm -rf /var/cache/apk/*

WORKDIR /home
RUN     set -ex; \
        wget https://dl.grafana.com/oss/release/grafana-7.4.1.linux-amd64.tar.gz; \
        tar -zxvf grafana-7.4.1.linux-amd64.tar.gz; \
        mv grafana-7.4.1 grafana; \
        rm grafana-7.4.1.linux-amd64.tar.gz; \
		mkdir /lib64; \
		ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2; \
		cp grafana/bin/grafana-server /usr/bin/; \
		sed -i -e 's/"search": false/"search": true/' /home/grafana/public/dashboards/home.json

WORKDIR /
COPY	./srcs/dashboards.yaml /home/grafana/conf/provisioning/dashboards/
COPY	./srcs/ft_services.json /home/grafana/data/dashboards/
COPY	./srcs/datasources.yaml /home/grafana/conf/provisioning/datasources/
COPY	./srcs/grafana.ini /home/grafana/conf/defaults.ini
COPY	./srcs/supervisord.conf /etc/supervisord.conf
RUN		set -ex; \
        chmod +r /home/grafana/conf/provisioning/dashboards/dashboards.yaml; \
        chmod +r /home/grafana/data/dashboards/ft_services.json; \
        chmod +r /home/grafana/conf/provisioning/datasources/datasources.yaml; \
        chmod +r /home/grafana/conf/defaults.ini; \
        chmod +r /etc/supervisord.conf

ENTRYPOINT	["supervisord","-c","/etc/supervisord.conf"]
