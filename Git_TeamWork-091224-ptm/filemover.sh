#!/bin/bash

# Запрос исходной и целевой директории у пользователя
read -p "Введите путь к исходной директории: " source_directory
read -p "Введите путь к целевой директории: " target_directory
# Запрос расширения файлов, которые нужно скопировать
read -p "Введите расширение файлов, которые нужно скопировать (например, .txt): " file_extension
echo "Вы выбрали расширение: $file_extension"
# Запросить новое расширение для файлов.
read -p "Enter new file extention with dot: " new_file_extention

# Проверка существования исходной директории
#if [ ! -d "$source_directory" ]; then
#    echo "Error: Source directory $source_directory does not exist."
#    read -p "Please enter a valid source directory: " source_directory
#fi

if [ ! -d "$source_directory" ] || [ ! -r "$source_directory" ]; then
    echo "Error: Source directory $source_directory does not exist or lacks read permissions."
    exit 1
fi

# Проверка существования целевой директории
#if [ ! -d "$target_directory" ]; then
#    echo "Error: Target directory $target_directory does not exist. Creating directory."
#    mkdir -p $target_directory
#    echo "Directory $target_directory created"
#fi

if [ ! -d "$target_directory" ] || [ ! -w "$target_directory" ]; then
    echo "Error: Target directory $target_directory does not exist or lacks write permissions."
    exit 1
fi

# Проверка, есть ли файлы с указанным расширением в исходной директории

if ! ls "$source_directory"/*"$file_extension"; then
    echo "Ошибка: файлы с расширением .$file_extension не найдены в папке $source_directory" 
    exit 1
fi

# Копирование файлов с указанным расширением в целевую директорию

for file in "$source_directory"/*"$file_extension"; do
  new_file="${target_directory}/$(basename "${file%$file_extension}")$new_file_extension"

  cp "$file" "$new_file"

  echo "Файл $file скопирован в $new_file"
done
