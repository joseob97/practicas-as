#!/bin/bash

ip route del default 2>/dev/null

iface_dev=$(ip -o -4 addr show | grep '172\.40\.' | awk '{print $2}' | head -n1)

if [[ -n "$iface_dev" ]]; then
    echo "Asignando gateway 172.40.0.1 a traves de $iface_dev"
    ip route add default via 172.40.0.1 dev "$iface_dev"
fi

echo "nameserver 172.20.0.6" > /etc/resolv.conf

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

mysqld_safe --skip-networking &
sleep 10

mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS drupal;
CREATE USER IF NOT EXISTS 'drupal'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON drupal.* TO 'drupal'@'%';
FLUSH PRIVILEGES;
EOF

mysqladmin -u root shutdown

exec mysqld