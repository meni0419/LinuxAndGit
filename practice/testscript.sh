#!/bin/bash

#Создать скрипт testscript.sh который выполняет следующее:
#● В каталоге /home создаст 5 каталогов с именами Dir1 … Dir5
#● В каждый из созданных каталогов создаст 5 файлов с интервалом 5 секунд с именами File1.txt
#… File5.txt
#● В каждый файл запишет текущие время в формате H-M-S
#● По окончанию создания каждого каталога со списком файлов выводит на экран список
#файлов.
#● Создаст сжатый tar архив в каталоге /tmp/Arh с именем Arh- «ТЕКУЩАЯ ДАТА» (Формат даты
#d-m-y) в архив упакует все созданные выше каталоги.
#● Создаст файл ArhList.txt со списком содержимого архива.
#● Разархивировать получившийся архив в новый путь /opt/newfolder/ сохранить структуру
#каталогов.
#В скрипте необходимо предусмотреть возможность изменить пути для создания и распаковки
#архива т.е используем переменные для этих путей.

TAR_PACK=${1:-/tmp/Arh}
TAR_UNPACK=${2:-/opt/newfolder/}

DATE_NOW=`date '+%y-%m-%d'`

mkdir -p $TAR_PACK

for i in {1..5}; do
  mkdir -p /home/Dir$i
  for j in {1..5}; do
    date '+%H-%M-%S' > /home/Dir$i/File$j.txt
    sleep 5
  done
  ls -lah /home/Dir$i
done

tar -cvf $TAR_PACK/Arh-$DATE_NOW.tar /home/Dir* >> $TAR_PACK/ArhList.txt

#ls -lah $TAR_PACK/Arh-$DATE_NOW.tar > $TAR_PACK/ArhList.txt

mkdir -p $TAR_UNPACK

tar -xvf $TAR_PACK/Arh-$DATE_NOW.tar -C $TAR_UNPACK

