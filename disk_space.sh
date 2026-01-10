#!/bin/bash

# Проверка доступности дискового просранства
check_disk_space()
{
    echo "Проверка доступности дискового пространства.."
    
    df -h | grep "^/dev/"
}

check_disk_space
