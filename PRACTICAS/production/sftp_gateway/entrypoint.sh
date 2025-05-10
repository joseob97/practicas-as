#!/bin/bash
set -e

ip route del default 2>/dev/null

iface_prod=$(ip -o -4 addr show | grep '172\.30\.' | awk '{print $2}' | head -n1)

if [[ -n "$iface_prod" ]]; then
    echo "Asignando gateway 172.30.0.1 a traves de $iface_prod"
    ip route add default via 172.30.0.1 dev "$iface_prod"
fi

echo "nameserver 172.20.0.6" > /etc/resolv.conf

groupadd sftpusers

while IFS=: read -r user dir; do
    useradd -m -d /home/$user -s /sbin/nologin -G sftpusers $user
    mkdir -p /home/$user/$dir
    chown root:root /home/$user
    chown $user:$user /home/$user/$dir
    echo "$user:password" | chpasswd
done < /usuarios.txt

mkdir -p /mnt/ftp_real

FTP_USER="anonymous"
FTP_PASS=""
FTP_IP="172.40.0.10"

for i in {1..5}; do
    echo "Intentando montar FTP remoto (intento $i)..."
    if curlftpfs ${FTP_USER}:${FTP_PASS}@${FTP_IP} /mnt/ftp_real -o allow_other,disable_epsv; then
        echo "Montaje FTP exitoso"
        break
    else
        echo "No se pudo montar el FTP. Esperando 10s..."
        sleep 10
    fi
done

ln -sfn /mnt/ftp_real /home/cliente/sftp_data

/usr/sbin/sshd -D