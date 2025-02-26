#!/bin/bash

# 1. Создайте скрипт sleeper.sh, который будет 10 раз с интервалом в 5 секунд писать дату в формате HH:MM:SS
# и количество процессов одним числом.
# 2. Уменьшите или уберите временной интервал (который нам дает sleep), используя vi или nano,
# закомментировав строку или поменяв значение sleep
# 3. С помощью скрипта запишите в файл информацию о процессоре.
# 4. С помощью скрипта запишите в файл информацию об операционной системе, но отфильтруйте информацию так,
# чтобы осталось только имя (NAME=Alpine Linux) - или другое имя, если работаете на сервере.
# 5. Выполните прошлое действие, но так, чтобы слово NAME= не осталось, а было только имя в чистом виде (Alpine)
# 6. С помощью скрипта создайте 50 файлов с расширением txt и именами от 50.txt до 100.txt


#!/bin/bash

# Функция для вывода времени и количества процессов
show_time_and_processes() {
    current_time=$(date +"%H:%M:%S")
    process_count=$(ps -e | wc -l)
    echo "Время: $current_time | Процессов: $process_count"
}

# Функция для мониторинга времени и процессов
monitor_time_and_processes() {
    echo "Начинаем мониторинг времени и процессов..."
    for i in {1..10}; do
        show_time_and_processes
        sleep 5  # Интервал в 5 секунд
    done
}

# Функция для уменьшения интервала sleep
reduce_sleep_interval() {
    echo "Уменьшаем интервал sleep..."
    # Используем sed для изменения значения sleep
    sed -i 's/sleep 5/sleep 1/' "$0"  # Меняем 5 на 1 секунду
    echo "Интервал уменьшен до 1 секунды."

    # Альтернативный вариант - закомментировать строку
    # sed -i 's/sleep 5/# sleep 5/' "$0"
}

# Функция для записи информации о процессоре
save_cpu_info() {
    echo "Записываем информацию о процессоре..."
    cpu_info_file="cpu_info.txt"
    cat /proc/cpuinfo > "$cpu_info_file"
    echo "Информация о процессоре записана в файл $cpu_info_file"
}

# Функция для записи информации об ОС
save_os_info() {
    echo "Записываем информацию об ОС..."
    os_info_file="os_info.txt"

    # Записываем строку с NAME= (например, NAME=Alpine Linux)
    grep "^NAME=" /etc/os-release > "$os_info_file"
    echo "Информация об ОС записана в файл $os_info_file"

    # Записываем только имя ОС без NAME= (например, Alpine Linux)
    os_name_file="os_name.txt"
    grep "^NAME=" /etc/os-release | cut -d= -f2 | tr -d '"' > "$os_name_file"
    echo "Имя ОС записано в файл $os_name_file"
}

# Функция для создания 50 файлов
create_files() {
    echo "Создаем 51 файл от 50.txt до 100.txt..."
    [ ! -d "50_files" ] && mkdir "50_files"
    for i in {50..100}; do
        touch "./50_files/$i.txt"
    done
    echo "Файлы созданы."
}

# Главное меню
show_menu() {
    echo "===== МЕНЮ СКРИПТА SLEEPER.SH ====="
    echo "1. Мониторинг времени и процессов (10 раз с интервалом 5 сек)"
    echo "2. Уменьшить интервал sleep до 1 секунды"
    echo "3. Записать информацию о процессоре в файл"
    echo "4. Записать информацию об ОС в файл"
    echo "5. Создать 51 файл от 50.txt до 100.txt"
    echo "6. Выполнить все задачи последовательно"
    echo "0. Выход"
    echo "=================================="
    echo -n "Выберите действие (0-6): "
    read choice

    case $choice in
        1) monitor_time_and_processes ;;
        2) reduce_sleep_interval ;;
        3) save_cpu_info ;;
        4) save_os_info ;;
        5) create_files ;;
        6)
            monitor_time_and_processes
            save_cpu_info
            save_os_info
            create_files
            ;;
        0) exit 0 ;;
        *) echo "Неверный выбор. Попробуйте снова." ;;
    esac
}

# Запуск меню
show_menu