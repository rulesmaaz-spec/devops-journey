echo "==================================="
echo "PROCESS INVESTIGATION REPORT"
echo "==================================="
echo "Date: $(date)"
echo "System Uptime: $(uptime -p)"
echo "Total Processes: $(ps aux --no-headers | wc -l)"
echo "Current User: $(whoami)"
echo "User Home Directory: $HOME"

echo ""
echo "TOP 5 PROCESSES BY MEMORY:"
echo "$(ps aux --sort=-%mem | head -4)"

echo ""
echo "TOP 5 PROCESSES BY CPU:"
echo "$(ps aux --sort=-%cpu --no-headers | head -4)"

echo ""
echo "PID 1 (init system): $(ps -p 1 -o comm=)"
echo "Shell PID: $$"
echo "Parent Shell PID: $(echo $PPID)"
echo "==================================="

