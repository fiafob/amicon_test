#!/bin/bash

LOG_FILE="/var/log/system_health.log"

log_warning() {
    local message="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') WARNING: $message" >> "$LOG_FILE"
}

cpu_threshold=80
memory_threshold=90
disk_threshold=80

# Чтение
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --cpu-threshold) cpu_threshold="$2"; shift ;;
        --memory-threshold) memory_threshold="$2"; shift ;;
        --disk-threshold) disk_threshold="$2"; shift ;;
        *) echo "Передан неправильный параметр: $1"; exit 1 ;;
    esac
    shift
done

# CPU
cpu_idle=$(top -bn1 | grep "Cpu(s)" | awk -F',' '{print $4}' | awk '{print int($1)}')
cpu_usage=$((100 - cpu_idle))
if [ "$cpu_usage" -gt "$cpu_threshold" ]; then
    echo "Загрузка ЦП выше нормы! В данный момент: $cpu_usage%"
    log_warning "Загрузка ЦП выше нормы! В данный момент: $cpu_usage%"
fi

# ОЗУ
memory_info=$(free | grep Mem)
memory_total=$(echo "$memory_info" | awk '{print $2}')
memory_used=$(echo "$memory_info" | awk '{print $3}')
memory_usage=$((memory_used * 100 / memory_total))
if [ "$memory_usage" -gt "$memory_threshold" ]; then
    echo "Загрузка ОЗУ выше нормы! В данный момент: $memory_usage%"
    log_warning "Загрузка ОЗУ выше нормы! В данный момент: $memory_usage%"
fi

# Диск
disk_usage=$(df / | grep / | awk '{print $5}' | sed 's/%//g')
if [ "$disk_usage" -gt "$disk_threshold" ]; then
    echo "Загрузка диска выше нормы! В данный момент: $disk_usage%"
    log_warning "Загрузка диска выше нормы! В данный момент: $disk_usage%"
fi
