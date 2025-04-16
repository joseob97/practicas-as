#!/bin/bash

#Actualizar paquetes e instalar dependencias
apt-get update
apt-get install -y cron postgresql-client default-mysql-client whois

# Crear directorio de backups si no existe
mkdir -p /backups

# Crear el script de backup
cat << 'EOF' > /backups/backup_databases.sh
#!/bin/bash
fecha=$(date +%F_%H-%M-%S)

# Backup de PostgreSQL
PGPASSWORD=password pg_dump -h 172.30.0.7 -U drupal drupal > /backups/pg_backup_$fecha.sql

# Backup de MySQL
mysqldump -h 172.40.0.6 -u drupal -ppassword drupal > /backups/mysql_backup_$fecha.sql
EOF

# Dar permisos de ejecucion al script
chmod +x /backups/backup_databases.sh

# Añadir entrada en el contrab si no existe
if ! grep -q backup_databases.sh /etc/crontab; then
	echo "0 2 * * * root /mnt/backups/backup_databases.sh" >> /etc/crontab
fi
# Añadir el usuario John Doe con clave Pfsense en caso que este no exista
if ! id "john_doe" &>/dev/null; then
	userad -m -s /bin/bash john_doe
	echo "john_doe:pfsense" | chpasswd
fi

# Iniciar cron
service cron start

# Mantener activo el contenedor
tail -f /dev/null
