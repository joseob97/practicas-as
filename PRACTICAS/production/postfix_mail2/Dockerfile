# postfix_mail /Dockerfile
FROM debian:bullseye

ENV DEBIAN_FRONTEND=nointeractive

RUN apt-get update && \
    apt-get install -y postfix mailutils sudo nano net-tools iputils-ping dnsutils iproute2 libsasl2-modules && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    

RUN useradd -m john && echo "john:john" | chpasswd && adduser john sudo

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
