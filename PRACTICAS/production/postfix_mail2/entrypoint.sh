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

postconf -e "myhostname = mail.production.com"
postconf -e "mydomain = production.com"
postconf -e "myorigin = \$mydomain"
postconf -e "inet_interfaces = all"
postconf -e "inet_protocols = ipv4"
postconf -e "mydestination = \$myhostname, localhost.\$mydomain, localhost"
postconf -e "relayhost ="
postconf -e "mynetworks = 127.0.0.0/8 172.30.0.0/24"
postconf -e "home_mailbox = Maildir/"
postconf -e "mailbox_command ="

# Arranca postfix en foreground
service postfix start

# Mantiene el contenedor activo
tail -f /dev/null
