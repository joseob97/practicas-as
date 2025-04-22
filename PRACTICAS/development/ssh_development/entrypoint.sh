#!/bin/bash

ip route del default 2>/dev/null

iface_dev=$(ip -o -4 addr show | grep '172\.40\.' | awk '{print $2}')

if [[ -n "$iface_dev" ]]; then
    echo "Asignando gateway 172.40.0.1 a traves de $iface_dev"
    ip route add default via 172.40.0.1 dev "$iface_dev"
fi

echo "nameserver 172.20.0.6" > /etc/resolv.conf

exec "$@"