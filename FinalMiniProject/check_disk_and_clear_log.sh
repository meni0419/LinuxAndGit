#!/bin/bash

#Порог свободного места в процентах
THRESHOLD=70

#Путь к лог-файлу Apache (httpd)
LOG_FILE="/var/log/httpd/access_log"

#Получаем процент свободного места на корневом разделе
FREE_SPACE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')

#Проверяем условие: если место меньше 70%, очищаем лог-файл
if [ "$FREE_SPACE" -gt "$THRESHOLD" ]; then
    sudo truncate -s 0 "$LOG_FILE"
fi