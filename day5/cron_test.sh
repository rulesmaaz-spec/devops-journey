#!/bin/bash
set -euo pipefail

LOG_FILE=$HOME/devops-journey/day5/cron-output.log

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Cron job executed successfully " >> "$LOG_FILE"
echo "User: $(whoami)" >> "$LOG_FILE"
echo "Uptime: $(uptime -p)" >> "$LOG_FILE"
echo "Memory free: $(free -h | awk '/^Mem:/ {print $4}')" >> "$LOG_FILE"
echo "----" >> "$LOG_FILE"

