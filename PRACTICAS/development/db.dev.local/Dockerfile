FROM debian:bullseye

USER root

RUN apt-get update && \
    DEBIAN_FRONTEND=nointeractive apt-get install -y \
    default-mysql-server \
    dnsutils \
    iputils-ping \
    net-tools \
    nano \
    iproute2 && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m  -s /bin/bash john && \
    echo "john:john" | chpasswd

COPY my.cnf /etc/mysql/mariadb.conf.d/99-bind.cnf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["/entrypoint.sh"]
CMD ["mysqld"]
