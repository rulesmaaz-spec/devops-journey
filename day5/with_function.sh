# ========================= With Function (Good CLean Reusable) ===================================

check_function() {
     local resource_name="$1"
     local value="$2"
     local threshold="$3"

     echo "========== checkin $resource_name =========="
     echo "$resource_name: $value"

     if [ "$(echo $value > $threshold | bc -l)" ]; then
        echo "WARNING!: $resource_name above $threshold%"
        return 1
     else
        echo "$resource_name is OK"
        return 0
     fi
}

cpu=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}')
mem=$(free -h | awk '/^Mem:/ {printf "%.1f", $3/$2*100}')
disk=$(df -h | awk 'NR==2 {print $5}'| tr -d '%')

check_function "CPU" "$cpu" 80
check_function "MEMORY" "$mem" 90
check_function  "DISK" "$disk" 85

# ========================================= GOOD PRACTICE ======================================
