# samba_ftp /Dockerfile
FROM debian:bullseye

ENV DEBIAN_FRONTEND=nointeractive

RUN apt update && apt install -y samba vsftpd sudo nano net-tools iputils-ping dnsutils iproute2

RUN useradd -m john && echo 'john:john' | chpasswd && usermod -aG sudo john

COPY conf/smb.conf /etc/samba/smb.conf
COPY conf/vsftpd.conf /etc/vsftpd,conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 21 139 445 40000-40010

CMD ["/entrypoint.sh"]
