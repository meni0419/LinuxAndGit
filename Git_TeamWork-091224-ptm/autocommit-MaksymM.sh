#!/bin/bash

# Этап 1: Проверка текущей директории на наличие репозитория Git
current_dir=$(pwd)
if [ ! -d "$current_dir/.git" ]; then
    echo "No changes to commit"
    exit 1
fi

# Этап 2: Добавление изменений в индекс
# Этап 3: Проверка наличия изменений для коммита
# Этап 4: Фиксация изменений и создание коммита
# Этап 5: Вывод сообщений об успешном выполнении или отсутствии изменений
if ! git status | grep -q "nothing to commit"; then
    git commit -am "autocommit $(date "+%Y-%m-%d-%H-%M-%S")"
    echo "autocommit $(date "+%Y-%m-%d-%H-%M-%S")"
fi
