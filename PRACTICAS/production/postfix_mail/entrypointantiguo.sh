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

#Configuracion postfix
postconf -e "myhostname = mail.production.com"
postconf -e "mydomain = production.com"
postconf -e "myorigin = production.com"
postconf -e "inet_interfaces = all"
postconf -e "inet_protocols = ipv4"
postconf -e "mydestination = mail.production.com, localhost.production.com, localhost"
postconf -e "relayhost ="
postconf -e "mynetworks = 127.0.0.0/8 172.30.0.0/24"
postconf -e "home_mailbox = Maildir/"
postconf -e "mailbox_command ="
postconf -e "maillog_file = /var/log/maillog"
postconf -e "virtual_alias_maps = hash:/etc/postfix/virtual"

# Crear alias para usuarios locales
echo "john@production.com   john" >> /etc/postfix/virtual
echo "root@production.com   root" >> /etc/postfix/virtual
postmap /etc/postfix/virtual

#Crear logs
touch /var/log/maillog
chmod 666 /var/log/maillog

#Asegurar que john tiene shell adecuado
chsh -s /bin/bash john
mkdir -p /home/john
chown john:john /home/john

#Crear buzon maildir en home de john
mkdir -p /home/john/Maildir/cur
mkdir -p /home/john/Maildir/new
mkdir -p /home/john/Maildir/tmp
chown -R john:john /home/john/Maildir

#Crear buzon maildir en home de root
mkdir -p /root/Maildir/cur
mkdir -p /root/Maildir/new
mkdir -p /root/Maildir/tmp
chown -R root:root /root/Maildir

#Configurar mutt para que root use Maildir automaticamente
echo 'set mbox_type=Maildir' > /root/.muttrc
echo 'set folder="~/Maildir"' >> /root/.muttrc
echo 'set spoolfile="~/Maildir"' >> /root/.muttrc
echo 'set from="root@production.com"' >> /root/.muttrc
echo 'set use_domain=no' >> /root/.muttrc
chown root:root /root/.muttrc

#Configurar mutt para que john use Maildir automaticamente
echo 'set mbox_type=Maildir' > /home/john/.muttrc
echo 'set folder="~/Maildir"' >> /home/john/.muttrc
echo 'set spoolfile="~/Maildir"' >> /home/john/.muttrc
echo 'set use_domain=no' >> /home/john/.muttrc
chown john:john /home/john/.muttrc

# Arranca postfix en foreground
service postfix start

# Mantiene el contenedor activo
tail -f /dev/null