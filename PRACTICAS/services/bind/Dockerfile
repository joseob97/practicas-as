# bind9_serv /Dockerfile
FROM ubuntu/bind9:latest

RUN apt update && \
    apt install -y dnsutils iputils-ping net-tools nano && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m  -s /bin/bash john && \
    echo "john:pfsense" | chpasswd

RUN id john

