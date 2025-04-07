FROM debian:latest

# Instalar paquetes necesarios (solo lo esencial para ping + tus requisitos)
RUN apt-get update && \
    apt-get install -y \
    isc-dhcp-server \
    iptables \
    iproute2 \
    iputils-ping  # <--- Este paquete habilita el comando ping

# Crear directorios necesarios
RUN mkdir -p /var/lib/dhcp

# Copiar el archivo de configuración del DHCP
COPY config/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf

# Configurar el comando de arranque desde docker-compose
CMD ["sleep", "infinity"]
