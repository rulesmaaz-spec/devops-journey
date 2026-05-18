#!/bin/bash
set -eou pipefail

# ===================================================
# FUNCTION DAFINATION (always define before calling)
# ===================================================

# Simple function - no argument
say_hello() {
    echo "Hello DevOps Engineer!"
    echo "Today is: $(date +%Y-%m-%d)"
}

# Function wit argument
greet_user() {
     local name="$1"              # First argument
     local role="${2:-Engineer}"  # Second argument with default value

     echo "Welcome $name"
     echo "Role: $role"
}

# Function that returns a value (via echo)
get_system_uptime() {
   local uptime_seconds
   uptime_seconds=$(awk '{print int($1)}' /proc/uptime)
   echo "$uptime_seconds"
}

# Function that return a status code (0=success, 1=failure)

is_service_running() {
   local service_name="$1"

   if systemctl is -active --quiet "$service_name" 2>/dev/null; then
      return 0
   else
      return 1
   fi
}

# Function with local variable
     calculate_disk_usage() {
         local mount_point="${1:=/}"
         local usage_percentage
         usage_percentage=$(df -h "$mount_point" | awk 'NR==2 {print $5}' | tr -d '%')

         echo "$usage_percentage"
         return 0
}


# =================================================
# USING THE FUNCTIONS
# =================================================

echo "============================================="
echo "        FUNCTION DEMONSTRATION"
echo "============================================="
echo ""

# call simple function
say_hello
echo ""

# call with argument
greet_user "Mohammad" "DevOps Engineer"
greet_user "Ahmad"
echo ""

# Capture function output
uptime_sec=$(get_system_uptime)
echo "System has been up for $uptime_sec seconds"
echo "thats approximately $(( uptime_sec / 3600)) hours "
echo ""

# Check return status
if is_service_running "sshd"; then
     echo "SSH is running"
else
     echo "SSH is not runnong"
fi
echo ""

# Get disk usage
disk_usage=$(calculate_disk_usage "/")
echo "Root partiton usage: ${disk_usage}%"


