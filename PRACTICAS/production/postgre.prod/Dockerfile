FROM bitnami/postgresql:latest

USER root

RUN install_packages dnsutils iputils-ping net-tools nano iproute2 sudo

RUN useradd -m john && echo "john:john" | chpasswd && adduser john sudo

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]