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

# Crear configuracion msmtp
cat <<EOF > /etc/msmtprc
defaults
auth           off
tls            off
logfile        /var/log/msmtp.log

account        default
host           mail.prod.local
port           25
from           john@apache.local
EOF

# Permisos msmtp
chmod 600 /etc/msmtprc

# Regiridir uso a msmtp y configurar mailutils
ln -sf /usr/bin/msmtp /usr/sbin/sendmail
echo 'set sendmail="/usr/bin/msmtp"' >> /etc/mail.rc

# Crear buzones locales para correo interno
mkdir -p /var/mail
touch /var/mail/john /var/mail/root
chown john:mail /var/mail/john
chown root:mail /var/mail/root
chmod 600 /var/mail/*


exec apache2ctl -D FOREGROUND
