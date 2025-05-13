#!/bin/bash

# Configurar gateway para producción
ip route del default 2>/dev/null
iface_prod=$(ip -o -4 addr show | grep 172\.30\. | awk '{print $2}' | head -n1)
if [[ -n "$iface_prod" ]]; then
  echo "Asignando gateway 172.30.0.1 a través de $iface_prod"
  ip route add default via 172.30.0.1 dev "$iface_prod"
fi

# DNS interno
echo "nameserver 172.20.0.6" > /etc/resolv.conf

htpasswd -cb /etc/apache2/.htpasswd documentos GraTiS!

exec apache2ctl -D FOREGROUND
