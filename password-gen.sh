#!/bin/bash

# Настройки по умолчанию
LENGTH=12        # Длина пароля
NUM_PASSWORDS=1  # Количество генерируемых паролей
USE_UPPER=true   # Использовать заглавные буквы
USE_LOWER=true   # Использовать строчные буквы
USE_NUMBERS=true # Использовать цифры
USE_SPECIAL=true # Использовать специальные символы

# Функция помощи
show_help() {
    echo "Скрипт генерации паролей"
    echo "Использование: $0 [опции]"
    echo "Опции:"
    echo "  -l, --length <число>    Длина пароля (по умолчанию: 12)"
    echo "  -n, --num <число>       Количество паролей (по умолчанию: 1)"
    echo "  -u, --upper             Включить заглавные буквы"
    echo "  -L, --lower             Включить строчные буквы"
    echo "  -d, --digits            Включить цифры"
    echo "  -s, --special           Включить спецсимволы"
    echo "  -h, --help              Показать эту справку"
    exit 0
}

# Парсинг опций
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -l|--length) LENGTH=$2; shift 2;;
        -n|--num) NUM_PASSWORDS=$2; shift 2;;
        -u|--upper) USE_UPPER=true; shift;;
        -L|--lower) USE_LOWER=true; shift;;
        -d|--digits) USE_NUMBERS=true; shift;;
        -s|--special) USE_SPECIAL=true; shift;;
        -h|--help) show_help;;
        *) echo "Неизвестная опция: $1"; show_help;;
    esac
done

# Проверка корректности параметров
if [[ $LENGTH -lt 1 ]]; then
    echo "Ошибка: длина пароля должна быть больше 0"
    exit 1
fi

if [[ $NUM_PASSWORDS -lt 1 ]]; then
    echo "Ошибка: количество паролей должно быть больше 0"
    exit 1
fi

# Создание набора символов
CHARSET=""
[[ $USE_UPPER == true ]] && CHARSET="${CHARSET}ABCDEFGHIJKLMNOPQRSTUVWXYZ"
[[ $USE_LOWER == true ]] && CHARSET="${CHARSET}abcdefghijklmnopqrstuvwxyz"
[[ $USE_NUMBERS == true ]] && CHARSET="${CHARSET}0123456789"
[[ $USE_SPECIAL == true ]] && CHARSET="${CHARSET}!@#$%^&*()_+-=[]{}|;:,.<>?/~`"

# Генерация паролей
for ((i=0; i<NUM_PASSWORDS; i++)); do
    PASSWORD=""
    for ((j=0; j<LENGTH; j++)); do
        PASSWORD="${PASSWORD}${CHARSET:$(($RANDOM % ${#CHARSET})):1}"
    done
    echo "$PASSWORD"
done
