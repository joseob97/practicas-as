# apache_web /Dockerfile
FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    nano \
    net-tools \
    iputils-ping \
    dnsutils \
    iproute2 \
    curl \
    netcat-openbsd \
    apache2 \
    apache2-utils \
 && rm -rf /var/lib/apt/lists/*

RUN useradd -m john && echo "john:john" | chpasswd && adduser john sudo

COPY httpd.conf /usr/local/apache2/conf/httpd.conf
COPY .htpasswd /usr/local/apache2/conf/.htpasswd
COPY errorphp.html /usr/local/apache2/htdocs/errorphp.html
COPY index.html /usr/local/apache2/htdocs/index.html
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
