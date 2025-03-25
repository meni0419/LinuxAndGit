#!/bin/bash

#1. Создайте на сервере linux.itcareerhub.de в своей папке /opt 2 дополнительных директории.
#2. В первой директории найдите способ (например написав скрипт или выполнив команду в терминале) создать 100 файлов со случайными названиями с использованием $RANDOM. Например файлы  15358 9396 240.
#3. Напишите скрипт, который будет переносить в другую директорию файлы, если число, стоящее в названии четное - то перенести файлы в другую директорию, если нет - оставить в текущей.

dir_even=/opt/091224-ptm/MaksymM/all_homeworks/homework_19/dir_even
dir_odd=/opt/091224-ptm/MaksymM/all_homeworks/homework_19/dir_odd
mkdir -p $dir_even && mkdir -p $dir_odd

for i in {1..100}; do
    touch $dir_odd/$RANDOM
done

for file in $dir_odd/*; do
    if [ $(( $(basename "$file" ) % 2 )) -eq 0 ]
 then
        mv $file $dir_even/
    fi
done
