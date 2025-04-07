#!/bin/bash

# Crear directorio de backups si no existe
mkdir -p /mnt/backups

# Crear el script de backup
cat << 'EOF' > /mnt/backups/backup_databases.sh
#!/bin/bash
fecha=$(date +%F_%H-%M-%S)

# Backup de PostgreSQL
PGPASSWORD=admin123 pg_dump -h 172.30.0.7 -U admin production_db > /mnt/backups/pg_backup_$fecha.sql

# Backup de MySQL
mysqldump -h 172.40.0.6 -u admin -padmin123 mydb > /mnt/backups/mysql_backup_$fecha.sql
EOF

# Dar permisos de ejecucion al script
chmod +x /mnt/backups/backup_databases.sh

# Añadir entrada en el contrab si no existe
if ! grep -q backup_databases.sh /etc/crontab; then
	echo "0 2 * * * root /mnt/backups/backup_databases.sh" >> /etc/crontab
fi
# Añadir el usuario John Doe con clave Pfsense en caso que este no exista
if ! id "john_doe" &>/dev/null; then
	userad -m -s /bin/bash john_doe
	echo "john_doe:Pfsense" | chpasswd
fi

# Iniciar cron
service cron start

# Mantener activo el contenedor
tail -f /dev/null
