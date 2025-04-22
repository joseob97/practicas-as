FROM nginx:latest

USER root

RUN apt-get update && apt-get install -y \
    dnsutils iputils-ping net-tools nano iproute2 sudo unzip wget curl && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m john && echo "john:john" | chpasswd && adduser john sudo

COPY custom-fix.sh /custom-fix.sh
RUN chmod +x /custom-fix.sh

CMD ["/bin/bash", "-c", "/custom-fix.sh & exec nginx -g 'daemon off;'"]