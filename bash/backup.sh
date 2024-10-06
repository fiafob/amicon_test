#!/bin/bash

# Проверка аргументов
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <source_directory> <backup_directory>"
    exit 1
fi

SOURCE_DIR="$1"         
BACKUP_DIR="$2"         
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S") # Текущая дата и время
BACKUP_FILE="$BACKUP_DIR/backup_$(basename "$SOURCE_DIR")_$TIMESTAMP.tar.gz" # Название архива

# Проверка существования исходной и целевой директории
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Заданной директории $SOURCE_DIR не существует."
    exit 1
fi

if [ ! -d "$BACKUP_DIR" ]; then
    echo "Error: Заданной директории $BACKUP_DIR не существует."
    exit 1
fi

# Создание архива
echo "Создание бэкапа $SOURCE_DIR в $BACKUP_FILE"
tar -czf "$BACKUP_FILE" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"

if [ $? -ne 0 ]; then
    echo "Error: Ошибка создания бэкапа."
    exit 1
fi

echo "Бэкап создан: $BACKUP_FILE"

BACKUP_COUNT=$(ls -1 "$BACKUP_DIR"/backup_* 2>/dev/null | wc -l)
if [ "$BACKUP_COUNT" -gt 5 ]; then
    echo "Найдено более 5 бэкапов. Удаляем предыдущие..."
    ls -1t "$BACKUP_DIR"/backup_* | tail -n +6 | xargs rm -f
    echo "Старые бэкапы удалены."
else
    echo "Предыдущие бэкапы НЕ будут удалены."
fi

