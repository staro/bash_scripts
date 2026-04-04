#!/bin/bash

# Настройки
EMAIL="${EMAIL:-staro.oleg@gmail.com}"
HOSTNAME=$(hostname)
LOG="/tmp/update-log.txt"

# Проверка прав суперпользователя
if [[ $EUID -ne 0 ]]; then
    echo "Запустите от root: sudo $0" >&2
    exit 1
fi

# Проверка наличия команды для отправки почты
if command -v mail >/dev/null 2>&1; then
    MAIL_CMD=(mail)
elif command -v mailx >/dev/null 2>&1; then
    MAIL_CMD=(mailx)
else
    echo "Нет команды mail/mailx. Установите: apt install mailutils" >&2
    exit 1
fi

# Обновляем пакеты и сохраняем лог (stdout + stderr)
{
    apt update && apt upgrade -y
} > "$LOG" 2>&1
apt_ec=$?

# Формируем тему письма
subject="[$HOSTNAME] Отчет об обновлении пакетов"
[[ $apt_ec -ne 0 ]] && subject="[$HOSTNAME] ОШИБКА обновления (код $apt_ec)"

# Отправляем лог на почту
if "${MAIL_CMD[@]}" -s "$subject" "$EMAIL" < "$LOG"; then
    # Успешная отправка — удаляем временный файл
    rm -f "$LOG"
else
    # Ошибка отправки — сообщаем и сохраняем лог
    echo "Не удалось отправить почту, лог сохранён: $LOG" >&2
    exit 1
fi

# Завершаем скрипт с кодом возврата команды apt
exit "$apt_ec"
