FROM debian:latest

RUN apt update && apt install -y wget gnupg lsb-release && \
    echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    apt update

RUN DEBIAN_FRONTEND=nointeractive apt-get install -y \
    cron \
    postgresql-client-17 \
    default-mysql-client \
    whois \
    dnsutils \
    iputils-ping \
    net-tools \
    nano \
    iproute2 && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m  -s /bin/bash john && \
    echo "john:john" | chpasswd

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

VOLUME /backups

ENTRYPOINT ["/entrypoint.sh"]
CMD ["tail", "-f", "/dev/null"]

