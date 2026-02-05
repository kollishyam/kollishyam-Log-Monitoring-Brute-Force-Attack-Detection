#!/bin/bash

LOGFILE="/var/log/auth.log"
ALERTFILE="$HOME/project2/alerts.log"
THRESHOLD=5

mkdir -p "$HOME/project2"
touch "$ALERTFILE"

echo "[+] Monitoring for brute force attacks..."

tail -Fn0 "$LOGFILE" | while read -r line; do
  echo "$line" | grep -q "Failed password" || continue

  IP=$(echo "$line" | awk '{for(i=1;i<=NF;i++) if($i=="from") print $(i+1)}')

  echo "$(date) Failed login from $IP" >> "$ALERTFILE"

  COUNT=$(grep -c "$IP" "$ALERTFILE")

  if [ "$COUNT" -eq "$THRESHOLD" ]; then
    echo "$(date) ALERT: Brute force attack detected from $IP" | tee -a "$ALERTFILE"
  fi
done

