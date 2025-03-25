#!/bin/bash

# Получаем текущую дату
DATE_BACKUP=$(date +%Y%m%d)

# Получаем дату за прошлую неделю
OLD_DATE=$(date -d last-week +%Y%m%d)

# Создаем архив лога
tar -cvf "/var/logs/$DATE_BACKUP-httpd.log.tar" httpd.log

# Формируем имя старого архива для удаления
OLD_BACKUP="$OLD_DATE-httpd.log.tar"

# Очищаем содержимое текущего лога
truncate -s 0 httpd.log

# Удаляем старый архив, если он существует
if [ -f "/var/logs/$OLD_BACKUP" ]; then
    rm -rf "/var/logs/$OLD_BACKUP"
fi
