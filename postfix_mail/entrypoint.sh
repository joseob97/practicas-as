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

#Generar main.cf
cat <<EOF > /etc/postfix/main.cf
myhostname = mail.production.com
mydomain = prod.local
myorigin = \$myhostname
inet_interfaces = all
inet_protocols = ipv4
mydestination = \$myhostname, localhost.\$mydomain, localhost, \$mydomain, mail.prod.local
mynetworks = 127.0.0.0/8, 172.30.0.0/24"
smtpd_banner = \$myhostname ESMTP
EOF

# Crear alias para usuarios locales
touch /etc/aliases
newaliases

# Crear buzones si no existen
mkdir -p /var/mail
touch /var/mail/root /var/mail/john
chown root:mail /var/mail/root
chown john:mail /var/mail/john
chmod 660 /var/mail/*

# Arranca postfix en foreground
service postfix start

# Mantiene el contenedor activo
tail -f /dev/null