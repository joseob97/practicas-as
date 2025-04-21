#!/bin/bash

ip route del default 2>/dev/null

iface_srv=$(ip -o -4 addr show | grep '172\.20\.' | awk '{print $2}')

if [[ -n "$iface_srv" ]]; then
    echo "Asignando gateway 172.20.0.1 a traves de $iface_srv"
    ip route add default via 172.20.0.1 dev "$iface_srv"
fi

echo "nameserver 172.20.0.6" > /etc/resolv.conf

exec "$@"