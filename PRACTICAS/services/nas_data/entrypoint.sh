#!/bin/bash

ip route del default 2>/dev/null

iface_srv=$(ip -o -4 addr show | grep '172\.20\.' | awk '{print $2}')

if [[ -n "$iface_srv" ]]; then
    echo "Asignando gateway 172.20.0.1 a traves de $iface_srv"
    ip route add default via 172.20.0.1 dev "$iface_srv"
fi

echo "nameserver 172.20.0.6" > /etc/resolv.conf

mkdir -p /backups

cat << 'EOF' > /backups/backup_databases.sh
#!/bin/bash
fecha=$(date +%F_%H-%M-%S)

PGPASSWORD=password pg_dump -h 172.20.0.7 -U drupal drupal > /backups/pg_backup_$fecha.sql

mysqldump -h 172.40.0.6 -u drupal -ppassword drupal > /backups/mysql_backup_$fecha.sql
EOF

chmod +x /backups/backup_databases.sh

if ! grep -q backup_databases.sh /etc/crontab; then
    echo "0 2 * * * root /backups/backup_databases.sh" >> /etc/crontab
fi

service cron start

exec "$@"