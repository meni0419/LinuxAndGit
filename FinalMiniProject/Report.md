## Цель проекта

Необходимо подключиться к серверу и восстановить его работоспособность, если известно, что на сервере работает
веб-сервер, работает веб-приложение и настроены бэкапы.  
По неизвестной причине сервис перестал работать.

---

## Процесс работы над проектом

1. **Проверка доступности сайта**  
   Получили ссылку на сайт [http://18.158.65.245/](http://18.158.65.245/) и убедились в том, что он не работает.  
   На странице вместо главной видим белый экран и сообщение о неправильном значении переменной `$wgServer` в файле
   `LocalSettings.php`.

2. **Проверка содержимого файла**  
   Сначала проверяем содержимое файла `/var/www/html/mediawiki/LocalSettings.php`, но получаем ошибку:
   > Error: Disk space exhausted  
   Это означает, что место на диске закончилось.

3. **Поиск папок, занимающих место**  
   Выполняем команду:
   ```bash
   sudo du --max-depth=1 -h /var/log/
   ```
   Обнаруживаем, что больше всего места занимают логи Apache в папке `httpd`.

4. **Анализ логов Apache**  
   Выполняем команду:
   ```bash
   sudo ls -lah /var/log/httpd
   ```
   Выясняется, что огромный объем занимает файл `access_log`, а также множество странных архивов.

5. **Проверка `crontab`**  
   Выполняем:
   ```bash
   sudo crontab -e
   ```
   Обнаруживаем там скрипт, который архивирует содержимое папки логов каждую минуту, включая уже созданные архивы.  
   Комментируем эту строку и сохраняем изменения. Теперь новые архивы не создаются.

6. **Очистка логов**  
   Проверяем статус сервиса Apache перед очисткой логов:
   ```bash
   sudo systemctl status httpd
   ```  
   Так как сервис запущен, сначала его останавливаем:
   ```bash
   sudo systemctl stop httpd
   ```  
   Затем удаляем файл логов и снова запускаем сервис:
   ```bash
   sudo rm -f /var/log/httpd/access_log
   sudo systemctl start httpd
   ```

7. **Удаление созданных архивов логов**  
   Для удаления архивов авторизуемся под рутом:
   ```bash
   sudo su
   rm -f /var/log/httpd/*.gz
   exit
   ```

8. **Создание регулярного скрипта для управления логами**  
   Создаем скрипт `archive_and_clean_logs.sh` и планируем его выполнение каждую ночь в 3:05.
   ```bash
   mkdir -p /home/ec2-user/backup_log
   sudo nano /home/ec2-user/backup_log/archive_and_clean_logs.sh
   ```

   **Содержимое скрипта:**
   ```bash
   #!/bin/bash
   # Скрипт выполняется в среде Bash

   LOG_DIR="/var/log" # Путь к директории с логами
   BACKUP_DIR="/home/ec2-user/backup_log" # Путь к папке для бэкапов
   DATE=$(date +%Y%m%d) # Текущая дата

   mkdir -p $BACKUP_DIR # Создаем папку для бэкапов

   tar -czf "$BACKUP_DIR/archive_$DATE.tar.gz" $LOG_DIR # Архивируем содержимое логов

   sudo systemctl stop httpd # Останавливаем httpd
   rm -f "$LOG_DIR/httpd/access_log" # Удаляем файл лога
   sudo systemctl start httpd # Перезапускаем httpd

   find "$BACKUP_DIR" -type f -name "*.tar.gz" -mtime +5 -exec rm -f {} + # Удаляем архивы старше 5 дней
   ```

   **Делаем скрипт исполняемым:**
   ```bash
   sudo chmod +x /home/ec2-user/backup_log/archive_and_clean_logs.sh
   ```

   **Добавляем задание в `crontab`:**
   ```bash
   sudo crontab -e
   ```
   Добавляем строку:
   ```bash
   5 3 * * * /home/ec2-user/backup_log/archive_and_clean_logs.sh
   ```

9. **Корректировка файла `LocalSettings.php`**  
   Проверяем файл:
   ```bash
   sudo nano /var/www/html/mediawiki/LocalSettings.php
   ```  
   Файл оказался пустым. Проверяем содержимое директории:
   ```bash
   sudo ls -lah /var/www/html/mediawiki/
   ```  
   Обнаруживаем файл с неправильным названием `LoclSettings.php`. Переименовываем:
   ```bash
   sudo mv /var/www/html/mediawiki/LoclSettings.php /var/www/html/mediawiki/LocalSettings.php
   ```

10. **Перезапуск Apache и проверка сайта**  
    Перезапускаем сервис:
    ```bash
    sudo systemctl restart httpd
    ```
    Проверяем сайт — он все еще не работает. Код статуса ответа — 301 (редирект).  
    Открываем файл `LocalSettings.php`:
    ```bash
    sudo nano /var/www/html/mediawiki/LocalSettings.php
    ```
    Находим неправильный IP-адрес в переменной `$wgServer`. Исправляем его на корректный IP и сохраняем.

11. **Финальная проверка работоспособности**  
    Снова перезапускаем Apache:
    ```bash
    sudo systemctl restart httpd
    sudo systemctl status httpd
    ```
    Сайт заработал. Задача завершена.

---

## Рекомендации

1. Устранить уязвимость при использовании команды `sudo su`.
2. Защитить сервер через услуги, например, StormWall.
3. Создать дополнительный скрипт `check_disk_and_clear_log.sh`, который будет запускаться каждый час и проверять
   свободное место на диске. Если свободное место меньше 70%, очищать логи Apache.

**Содержимое скрипта:**

```bash
#!/bin/bash

# Порог свободного места в процентах
THRESHOLD=70

# Путь к лог-файлу Apache (httpd)
LOG_FILE="/var/log/httpd/access_log"

# Получаем процент свободного места на корневом разделе
FREE_SPACE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')

# Проверяем условие: если место меньше 70%, очищаем файл логов
if [ "$FREE_SPACE" -gt "$THRESHOLD" ]; then
    sudo truncate -s 0 "$LOG_FILE"
fi
```

**Делаем файл исполняемым и добавляем его в `crontab`:**

```bash
sudo nano /home/ec2-user/backup_log/check_disk_and_clear_log.sh
sudo chmod +x /home/ec2-user/backup_log/check_disk_and_clear_log.sh
sudo crontab -e
```

Добавляем строку:

```bash
5 * * * * /home/ec2-user/backup_log/check_disk_and_clear_log.sh
```

---

Спасибо за хороший курс!