#!/bin/bash

#!/bin/bash

# Получение текущей даты в формате ДД.ММ.ГГ (например, 20.04.23)
CURRENT_DATE=$(date +"%d.%m.%y")

# Каталог для создания файлов (можно заменить, если необходимо)
TARGET_DIR="/opt/091224-ptm/MaksymM/all_homeworks/homework_12/files"

# Проверяем, существует ли каталoг, если нет — создаём
if [ ! -d "$TARGET_DIR" ]; then
  mkdir -p "$TARGET_DIR"
fi

# Цикл для создания 10 файлов
for i in {1..10}; do
  FILE_NAME="${i}_${CURRENT_DATE}"           # Формируем имя файла
  touch "$TARGET_DIR/$FILE_NAME"            # Создаём файл
  echo "Создан файл: $TARGET_DIR/$FILE_NAME" # Вывод сообщения о создании
done