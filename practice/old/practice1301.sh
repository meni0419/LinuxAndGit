#!/bin/bash

# 1. Вывести доступное дисковое пространство для всех дисков
echo "1. Вывести доступное дисковое пространство для всех дисков, но в формате - только название диска и доступное пространство:"
echo "Команда:"
echo "df -h --output=source,avail | tail -n +2"
echo "Результат выполнения команды:"
df -h --output=source,avail
echo ""

# 2. Подсчитать количество строк, где строка содержит слово root
echo "2. Из файла /etc/group подсчитать количество строк, где строка содержит слово root с использованием grep и wc:"
echo "Команда:"
echo "grep -c 'root' /etc/group"
echo "Результат выполнения команды:"
grep -c 'mm' /etc/group
echo ""

# 3. Вывести только 2 столбец. Сколько 'x' и сколько '*'?
echo "3. Из файла /etc/group - вывести только 2 столбец. Сколько 'x' и сколько '*'?"
echo "Команда для 'x':"
echo "awk -F: '{print \$2}' /etc/group | grep -o 'x' | wc -l"
echo "Результат выполнения команды:"
awk -F: '{print $2}' /etc/group | grep -o 'x' | wc -l
echo ""
echo "Команда для '*':"
echo "awk -F: '{print \$2}' /etc/group | grep -o '*' | wc -l"
echo "Результат выполнения команды:"
awk -F: '{print $2}' /etc/group | grep -o '*' | wc -l
echo ""

# 4. Проверить, что можно работать с разделителем
echo "4. Проверить, что можно работать с разделителем:"
echo "Команда:"
echo "awk -F: '{print \$2}' /etc/group"
echo "Результат выполнения команды:"
awk -F: '{print $2}' /etc/group
echo ""

# 5. Записать последние 3 строки из файла /etc/group в отдельный файл и заменить 1000 на 777
echo "5. Записать последние 3 строки из файла /etc/group в отдельный файл и заменить 1000 на 777:"
echo "Команда:"
echo "tail -n 3 /etc/group > /tmp/last3lines.txt && sed -i 's/1000/777/g' /tmp/last3lines.txt"
echo "Результат выполнения команды:"
echo "" > ~/last3lines.txt
tail -n 3 /etc/group > ~/last3lines.txt
sed -i 's/1000/777/g' ~/last3lines.txt
cat ~/last3lines.txt
echo ""

# 6. Заменить в файле /tmp/file user2 на user1 user2 user3
echo "6. Заменить в файле /tmp/file user2 на user1 user2 user3:"
echo "Команда:"
echo "sed -i 's/user2/user1 user2 user3/g' /tmp/file"
echo "Результат выполнения команды:"
touch /tmp/file
echo "" > /tmp/file
sed -i 's/User2/User3/g; s/User1/User2/g' /tmp/file
cat /tmp/file
echo ""

# 7. Дописать в файл /tmp/file всех пользователей из /etc/passwd (первый столбец)
echo "7. Дописать в файл /tmp/file всех пользователей из /etc/passwd (первый столбец):"
echo "Команда:"
echo "awk -F: '{print \$1}' /etc/passwd >> /tmp/file"
echo "Результат выполнения команды:"
awk -F: '{print $1}' /etc/passwd >> /tmp/file
cat /tmp/file
echo ""

# 8. Дописать в начале каждой строки слово Username
echo "8. Дописать в начале каждой строки слово Username:"
echo "Команда:"
echo "sed -i 's/^/Username /' /tmp/file"
echo "Результат выполнения команды:"
sed -i 's/^/Username /' /tmp/file
cat /tmp/file
echo ""

# example cycle for
for ((i=0; i<20; i++))
#for i in $(seq 0 19)
  do
    date >> file.txt
    sleep 2
  done