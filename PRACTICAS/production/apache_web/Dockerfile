# apache_web /Dockerfile
FROM debian:bullseye

RUN apt-get update && apt-get install -y \
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

RUN a2enmod headers auth_basic

RUN useradd -m john && echo "john:john" | chpasswd && adduser john sudo

COPY errorphp.html /var/www/html/errorphp.html
COPY index.html /var/www/html/index.html
COPY prueba.php /var/www/html/prueba.php
COPY default.conf /etc/apache2/sites-available/000-default.conf
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
