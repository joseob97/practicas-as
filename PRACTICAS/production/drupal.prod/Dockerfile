FROM php:8.3-fpm

USER root

RUN apt-get update && apt-get install -y \
    libpq-dev  libjpeg-dev libpng-dev libfreetype6-dev \
    dnsutils iputils-ping net-tools nano iproute2 sudo unzip wget curl gnupg \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo_pgsql pgsql gd

RUN useradd -m john && echo "john:john" | chpasswd && adduser john sudo

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]