#!/bin/bash
set -e

# Configurar gateway para producción
ip route del default 2>/dev/null
iface_prod=$(ip -o -4 addr show | grep 172\.30\. | awk '{print $2}' | head -n1)
if [[ -n "$iface_prod" ]]; then
  echo "Asignando gateway 172.30.0.1 a través de $iface_prod"
  ip route add default via 172.30.0.1 dev "$iface_prod"
fi

# DNS interno
echo "nameserver 172.20.0.6" > /etc/resolv.conf

# Crear punto de montaje
mkdir -p /mnt/ftp_real

# Variables de conexión FTP anónimo
FTP_USER="anonymous"
FTP_PASS=""
FTP_IP="172.40.0.10"

# Esperar que puerto 21 esté disponible
echo "Esperando que el puerto FTP 21 esté disponible en $FTP_IP..."
while ! nc -z -w 1 $FTP_IP 21; do
  echo "Puerto 21 aún no disponible, esperando 5s..."
  sleep 5
done

# Intentar montar FTP remoto
for i in {1..5}; do
  echo "Intentando montar FTP remoto (intento $i)..."
  if curlftpfs ${FTP_USER}:${FTP_PASS}@$FTP_IP /mnt/ftp_real -o allow_other,disable_epsv; then
    echo "Montaje FTP exitoso"
    break
  else
    echo "No se pudo montar el FTP. Esperando 10s..."
    sleep 10
  fi
done

# Crear enlace simbólico para el usuario sftp
ln -sfn /mnt/ftp_real /home/cliente/sftp_data

# Ejecutar SSH
/usr/sbin/sshd -D