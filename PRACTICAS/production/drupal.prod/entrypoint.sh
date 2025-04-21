#!/bin/bash

ip route del default 2>/dev/null

iface_prod=$(ip -o -4 addr show | grep '172\.30\.' | awk '{print $2}' | head -n1)

if [[ -n "$iface_prod" ]]; then
    echo "Asignando gateway 172.30.0.1 a traves de $iface_prod"
    ip route add default via 172.30.0.1 dev "$iface_prod"
fi

echo "nameserver 172.20.0.6" > /etc/resolv.conf

if [[ -f /iniciodrupal.sh ]]; then
    echo "Ejecutando iniciodrupal.sh"
    bash /iniciodrupal.sh
else
    echo "Script iniciodrupal.sh no encontrado"
fi

exec php-fpm