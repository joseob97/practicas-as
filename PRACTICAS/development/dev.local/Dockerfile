FROM drupal:10-apache

RUN apt-get update && apt-get install -y \
    iproute2 \
    iputils-ping \
    dnsutils \
    net-tools \
    nano \
    vim \
    sudo \
    && apt-get clean

RUN useradd -m -s /bin/bash john && \
    echo 'john:john' | chpasswd && \
    usermod -aG sudo john

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]

