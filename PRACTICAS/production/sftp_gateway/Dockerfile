# sftp_gateway /Dockerfile
FROM debian:bullseye

ENV DEBIAN_FRONTEND=nointeractive

RUN apt update && apt install -y \
    openssh-server \
    curlftpfs \
    sudo \
    nano \
    netcat-openbsd \
    net-tools \
    iputils-ping \
    dnsutils \
    iproute2

RUN useradd -m john && echo "john:john" | chpasswd && adduser john sudo

RUN useradd -m -d /home/cliente -s /bin/bash cliente && \
    echo "cliente:password" | chpasswd && \
    mkdir -p /home/cliente/sftp_data && \
    chown cliente:cliente /home/cliente/sftp_data

RUN mkdir /var/run/sshd

COPY sshd_config /etc/ssh/sshd_config
COPY entrypoint.sh /entrypoint.sh
COPY usuarios.txt /usuarios.txt
RUN chmod +x /entrypoint.sh

EXPOSE 22

CMD ["/entrypoint.sh"]