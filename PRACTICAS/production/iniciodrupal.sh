#!/bin/bash

# Copiar Drupal al volumen compartido si esta vacio
if [ -z "$(ls -A /app)" ]; then
    cp -r /opt/bitnami/nginx/html/* /app/
fi

# Establecer permisos
chown -R 1001:1001 /app

# Iniciar PHP-FPM
/opt/bitnami/php/sbin/php-fpm -F