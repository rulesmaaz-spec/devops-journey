#!/bin/bash

# BAD - repetitives
echo "===== Checking CPU Process ====="
cpu=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}')
echo "CPU: $cpu%"

echo "===== Checking Memory ====="
mem=$(free | awk '/^Mem:/ {print "%.1f", $3/$2*100}')
echo "Memory: $mem%"

echo "===== Checking Disk ====="
disk=$(df -h / | awk 'NR==2 {print $5}')
echo "Disk: $disk%"

# ===================================== BAD PRACTICE ====================================
