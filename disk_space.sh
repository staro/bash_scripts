#!/bin/bash

# bash сккрипт, который отправит письмо, если свободного места на диске останется меньше 10%

# 1. Для использования скрипта необходима установка mailx
# 2. Необходимо изменить переменную EMAIL на свой адрес электронной почты
# 3. Необходимо добавить скрипт в cron, чтобы он выполнялся, например каждый час.
 

# Если мпньше 10% отправляем сообщение
THRESHOLD=10
EMAIL="admin@email.ru"

# Исключаем tmpfs, devtmpfs и другие виртуальные ФС
df -hP | grep -vE '^Filesystem|tmpfs|devtmpfs|udev|none' | while IFS=$'\t' read -r _ _ _ _ USAGE MOUNT _; do
    # Удаляем символ % и преобразуем в число
    USAGE_NUM=${USAGE%\%}

    # Проверяем, что USAGE_NUM — число
    if ! [[ "$USAGE_NUM" =~ ^[0-9]+$ ]]; then
        continue
    fi

    # Проверка порога
    if [ "$USAGE_NUM" -ge "$((100 - THRESHOLD))" ]; then
        # Формируем сообщение
        MESSAGE="На сервере $(hostname)\n"
        MESSAGE+="Монтирование: $MOUNT\n"
        MESSAGE+="Занято: $USAGE\n"
        MESSAGE+="Время проверки: $(date '+%Y-%m-%d %H:%M:%S')\n"

        # Отправляем письмо
        echo -e "$MESSAGE" | mail -s "ВНИМАНИЕ: Мало места на диске $MOUNT" "$EMAIL"
    fi
done
