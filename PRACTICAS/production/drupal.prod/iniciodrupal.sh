#!/bin/bash

cd /app

if [ ! -f index.php ]; then
    echo "Instalando Drupal..."
    curl -L -o drupal.tar.gz https://www.drupal.org/download-latest/tar.gz    
    tar -xzf drupal.tar.gz --strip-components=1
    rm drupal.tar.gz
else
    echo "Drupal ya esta instalado."
fi

if [ ! -f sites/default/settings.php ]; then
    echo "[+] Copiando settings.php..."
    cp sites/default/default.settings.php sites/default/settings.php
    chmod 664 sites/default/settings.php
else
    echo "[i] settings.php ya existe.."
fi

mkdir -p sites/default/files/translations
chmod -R ug+rw sites/default/files

echo "[i] Drupal instalado y listo."