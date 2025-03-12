#!/bin/sh

read -p "Введите адрес: " address

missed_pings=0

while true; do
  if [ "$missed_pings" -ge 3 ]; then
    echo "❌ Пинг не удается выполнить в течение 3 попыток!"
    echo "$ping_time"
    exit 1
  fi

  ping_result=$(ping -c 1 $address 2>/dev/null)

  if [ $? -eq 0 ]; then
    ping_time=$(echo "$ping_result" | grep "time=" | sed -E 's/.*time=([0-9]+).*/\1/')
    if [ "$ping_time" -gt 100 ]; then
      echo "⚠️ Время пинга ${address} превышает 100 мс: ${ping_time} мс"
    else
      echo "Пинг ${address} успешен: ${ping_time} мс"
    fi
  else
    echo "Пинг ${address} не удался."
    missed_pings=$((missed_pings + 1))
  fi
  sleep 1
done