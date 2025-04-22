# bind9_serv /Dockerfile
FROM ubuntu/bind9:latest

RUN apt update && \
    apt install -y dnsutils iputils-ping net-tools nano iproute2 && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m  -s /bin/bash john && \
    echo "john:john" | chpasswd

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/named", "-g"]

