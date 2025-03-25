#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Использование: $0 <адрес_для_пинга>"
    exit 1
fi
# Получение адреса из аргумента командной строки
address=$1
# Запрос количества пингов у пользователя
echo -n "Введите количество запросов для проверки: "
read count
# Проверка, что введено число
if ! [[ "$count" =~ ^[0-9]+$ ]]; then
    echo "Ошибка: Введите положительное целое число"
    exit 1
fi
# Выполнение команды ping и сохранение вывода в переменную
echo "Выполняется пинг $address с количеством запросов $count..."
ping_output=$(ping -c $count $address)
# Проверка, был ли ping успешным
if [ $? -ne 0 ]; then
    echo "Ошибка при выполнении ping. Проверьте адрес и доступность сети."
    exit 1
fi
# Извлечение строки со средним значением времени (rtt)
# Для разных локализаций ping может выводить разные форматы
if echo "$ping_output" | grep -q "min/avg/max"; then
    # Английская локализация
    avg_time=$(echo "$ping_output" | grep "min/avg/max" | awk -F'/' '{print $5}')
elif echo "$ping_output" | grep -q "мин/срд/макс"; then
    # Русская локализация
    avg_time=$(echo "$ping_output" | grep "мин/срд/макс" | awk -F'/' '{print $5}')
else
    echo "Не удалось определить формат вывода ping"
    exit 1
fi
# Вывод результата
echo "Среднее время ответа: $avg_time мс"