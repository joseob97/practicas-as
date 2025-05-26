# postfix_mail /Dockerfile
FROM debian:bullseye

ENV DEBIAN_FRONTEND=nointeractive

RUN apt update && apt install -y \
    postfix \
    mailutils \
    sudo \
    nano \
    net-tools \
    iputils-ping \
    dnsutils \
    iproute2 

RUN useradd -m john && echo "john:john" | chpasswd && adduser john sudo

COPY config/main.cf /etc/postfix/main.cf

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
