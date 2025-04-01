#!/bin/bash
# Скрипт выполняется в среде Bash

LOG_DIR="/var/log" # переменная директории с логами
BACKUP_DIR="/home/ec2-user/backup_log" # переменная для пути создания бэкапов
DATE=$(date +%Y%m%d) # переменная текущей даты (по скольку раз в сутки то не нужны часы и минуты -%H%M)

mkdir -p $BACKUP_DIR # Создаем папку для бэкапов, создавая недостающие директории при необходимости -p

tar -czf "$BACKUP_DIR/archive_$DATE.tar.gz" $LOG_DIR # Архивируем содержимое папки логов и сохраняем архив в папке бэкапов

sudo systemctl stop httpd # останавливаем сервис httpd
rm -f "$LOG_DIR/httpd/access_log" # Удаляем файл логов httpd (т.к. он пересоздается при перезапуске сервиса)
sudo systemctl start httpd # запускаем сервис httpd

find "$BACKUP_DIR" -type f -name "*.tar.gz" -mtime +5 -exec rm -f {} +; # Ищем архивы старше 5 дней и удаляем их
