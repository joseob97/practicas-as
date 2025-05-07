#!/bin/bash

ip route del default 2>/dev/null

iface_dev=$(ip -o -4 addr show | grep '172\.40\.' | awk '{print $2}')

if [[ -n "$iface_dev" ]]; then
    echo "Asignando gateway 172.40.0.1 a traves de $iface_dev"
    ip route add default via 172.40.0.1 dev "$iface_dev"
fi

echo "nameserver 172.20.0.6" > /etc/resolv.conf

for i in {1..5}; do
    useradd -M -s /sbin/nologin empleado$i
    echo -e "password\npassword" | smbpasswd -a -s empleado$i
done

useradd -M -s /sbin/nologin revisor
echo -e "password\npassword" | smbpasswd -a -s revisor

for i in {1..5}; do
    mkdir -p /data/desarrollo/SW$i
    mkdir -p /data/revision/SW$i
    mkdir -p /data/publico/SW$i

    chown -R empleado$i:empleado$i /data/desarrollo/SW$i
    chmod -R 770 /data/desarrollo/SW$i

    chown -R empleado$i:revisor /data/revision/SW$i
    chmod -R 770 /data/revision/SW$i

    chown -R revisor:revisor /data/publico/SW$i
    chmod -R 755 /data/publico/SW$i
done

/usr/sbin/vsftpd /etc/vsftpd.conf &
/usr/sbin/smbd -F --no-process-group