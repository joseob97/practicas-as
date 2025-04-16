#!/bin/bash
fecha=$(date +%F_%H-%M-%S)

# Backup de PostgreSQL
PGPASSWORD=password pg_dump -h 172.30.0.7 -U drupal drupal > /backups/pg_backup_$fecha.sql

# Backup de MySQL
mysqldump -h 172.40.0.6 -u drupal -ppassword drupal > /backups/mysql_backup_$fecha.sql
