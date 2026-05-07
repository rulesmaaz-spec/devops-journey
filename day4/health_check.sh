#!/bin/bash

# =========================================================
# Script: health_check.sh
# Description: Production-grade system health checker
# Author: Mohammad Maaz
# Date: 2026-05-06
# Usage: ./health_check.sh [--verbose]
# =========================================================

set -euo pipefail

# Configuration
CPU_THRESHOLD=80   # Alert if CPU usage exceeds this %
MEM_THRESHOLD=80   # Alert if memory usage exceeds this %
DISK_THRESHOLD=80  # Alert if disk usage exceeds this %
LOG_DIR="$HOME/devops-journey/day4/logs"
REPORT_FILE="$LOG_DIR/health_report-$(date +%Y%m%d-%H%M%S).txt"
VERBOSE=false

# Parse argument 
if [[ "${1:-}" == "--verbose" ]]; then
    VERBOSE=true
fi

# Creating log directory
mkdir -p "$LOG_DIR"

# Function to print section header
print_header() {
     echo "=============================="
     echo "             $1"
     echo "=============================="
}

# Function to check if command exists
command_exist() {
    command -v "$1" >/dev/null 2>&1
}

# Start Report
{
   print_header "SYSTEM HEALTH CHECK REPORT"
   echo "Generated: $(date)"
   echo "Hostname: $(hostname)"
   echo "Kernel: $(uname -r)"
   echo "Uptime: $(uptime -p)"
   echo ""

   # === CPU Check ===
   print_header "CPU USAGE"
   if command_exist mpstat; then
       cpu_idle=$(mpstat 1 1 | tail -1 | awk '{print $NF}')
       cpu_usage=$(awk -v idle="$cpu_idle" 'BEGIN {printf "%.1f", 100 - idle}')
   else
       # Fallback: parse top output
       cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
   fi

   echo "Current CPU Usage: ${cpu_usage}%"

   if (( $(echo "$cpu_usage > $CPU_THRESHOLD" | bc -l) )); then
       echo "WARNING: CPU usage above ${CPU_THRESHOLD}% threshold!"
   else
       echo "CPU Usage is within limit"
   fi
   echo ""

   # === Memory Check ===
   print_header "MEMORY USAGE"
   mem_total=$(free -h | awk '/^Mem:/ {print $2}')
   mem_used=$(free -h | awk '/^Mem:/ {print $3}')
   mem_free=$(free -h | awk '/^Mem:/ {print $4}')
   mem_percent=$(free | awk '/^Mem:/ {printf "%.1f", $3/$2 * 100}')

   echo "Total Memory: $mem_total"
   echo "Used Memory: $mem_used"
   echo "Free Memory: $mem_free"
   echo "Usage: ${mem_percent}%"

   if (( $(echo "$mem_percent > $MEM_THRESHOLD" | bc -l) )); then
       echo "WARNING: Memory usage above ${MEM_THRESHOLD}% threshold"
   else
       echo "Memory usage is within limit"
   fi
   echo ""

   # === Disk Check ===
   print_header "DISK USAGE"
   df -h | grep -vE '^Filesystem|tmpfs|devtmpfs' | while read -r line; do
       filesystem=$(echo "$line" | awk '{print $1}')
       size=$(echo "$line" | awk '{print $2}')
       used=$(echo "$line" | awk '{print $3}')
       avail=$(echo "$line" | awk '{print $4}')
       percent=$(echo "$line" | awk '{print $5}' | tr -d '%')
       mount=$(echo "$line" | awk '{print $6}')

       echo "  Mount: $mount ($filesystem)"
       echo "  Size: $size, Used: $used, Available: $avail"

       if [ "$percent" -gt "$DISK_THRESHOLD" ]; then
           echo "  WARNING: Disk usage at ${percent}% on $mount"
       else
           echo "  Disk usage is within limit"
       fi
       echo ""
   done

   # === Process Check ===
   print_header "TOP 5 PROCESSES BY CPU"
   ps aux --sort=-%cpu | head -6 | tail -5 | awk '{printf "  %s (PID: %s) - CPU: %s%%, MEM: %s%%\n", $11, $2, $3, $4}'
   echo ""

   print_header "TOP 5 PROCESSES BY MEMORY"
   ps aux --sort=-%mem | head -6 | tail -5 | awk '{printf "  %s (PID: %s) - CPU: %s%%, MEM: %s%%\n", $11, $2, $3, $4}'
   echo ""

   # === Service Check ===
   print_header "CRITICAL SERVICE STATUS"
   services=("sshd" "systemd-journald" "systemd-resolved")

   for service in "${services[@]}"; do
       if systemctl is-active --quiet "$service" 2>/dev/null; then
           echo "  $service: Running"
       else
           echo "  $service: NOT running"
       fi
   done
   echo ""

   # === Network Check ===
   print_header "NETWORK CONNECTIVITY"
   if ping -c 1 -W 2 8.8.8.8 >/dev/null 2>&1; then
       echo "Internet Connectivity: OK"
   else
       echo "Internet Connectivity: FAILED"
   fi

   if ping -c 1 -W 2 1.1.1.1 >/dev/null 2>&1; then
       echo "DNS Resolution: OK"
   else
       echo "DNS Resolution: FAILED"
   fi
   echo ""

   # === Verbose Output ===
   if [ "$VERBOSE" = true ]; then
       print_header "VERBOSE SYSTEM INFO"
       echo "CPU Info:"
       lscpu | grep "Model name" | sed 's/Model name:/  /'
       echo ""
       echo "Network Interfaces:"
       ip -brief addr
       echo ""
       echo "Recent Auth Log (last 5):"
       tail -5 /var/log/auth.log 2>/dev/null || echo "  Cannot read auth.log"
   fi

   print_header "REPORT COMPLETE"
   echo "Report saved to: $REPORT_FILE"

} | tee "$REPORT_FILE"

# Print summary
echo ""
echo "========================================="
echo " HEALTH CHECK COMPLETE"
echo " Report: $REPORT_FILE"
echo "========================================="
