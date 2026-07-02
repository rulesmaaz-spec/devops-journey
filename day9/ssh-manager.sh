#!/bin/bash
#
# Script: ssh-manager.sh
# Description: SSH connection manager for your ~/.ssh/config hosts
# Author: Mohammad Maaz
# Usage: ./ssh-manager.sh [list|test|tunnel <host>]
#

set -euo pipefail

SSH_CONFIG="$HOME/.ssh/config"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Function: list all hosts from config
list_hosts() {
    echo -e "${CYAN}Hosts in $SSH_CONFIG:${NC}"
    grep -E "^Host " "$SSH_CONFIG" | grep -v "Host \*" | while read -r line; do
        host=$(echo "$line" | awk '{print $2}')
        hostname=$(grep -A10 "Host $host$" "$SSH_CONFIG" | grep "HostName" | head -1 | awk '{print $2}')
        user=$(grep -A10 "Host $host$" "$SSH_CONFIG" | grep "User" | head -1 | awk '{print $2}')
        proxy=$(grep -A10 "Host $host$" "$SSH_CONFIG" | grep "ProxyJump" | head -1 | awk '{print $2}')
        echo "  ${GREEN}$host${NC} -> ${user:-unknown}@${hostname:-unknown} ${proxy:+via $proxy}"
    done
}

# Function: test connection to a host
test_host() {
    local host="$1"
    echo -n "Testing SSH to $host ... "
    if ssh -o ConnectTimeout=5 -o BatchMode=yes "$host" "echo OK" &>/dev/null; then
        echo -e "${GREEN}Connected${NC}"
    else
        echo -e "${RED}Failed${NC}"
    fi
}

# Function: quick tunnel setup
tunnel_host() {
    local host="$1"
    local local_port="${2:-8080}"
    local remote_host="${3:-localhost}"
    local remote_port="${4:-80}"
    
    echo "Creating tunnel: localhost:$local_port -> $remote_host:$remote_port via $host"
    ssh -N -L "${local_port}:${remote_host}:${remote_port}" "$host" &
    local pid=$!
    sleep 1
    if kill -0 $pid 2>/dev/null; then
        echo -e "${GREEN}Tunnel established (PID $pid). Access at http://localhost:$local_port${NC}"
        echo "To close: kill $pid"
    else
        echo -e "${RED}Tunnel failed.${NC}"
    fi
}

# Main
ACTION="${1:-list}"
case "$ACTION" in
    list)
        list_hosts
        ;;
    test)
        if [[ -z "${2:-}" ]]; then
            echo "Usage: $0 test <host>"
            exit 1
        fi
        test_host "$2"
        ;;
    tunnel)
        if [[ -z "${2:-}" ]]; then
            echo "Usage: $0 tunnel <host> [local_port] [remote_host] [remote_port]"
            echo "Example: $0 tunnel bastion 8080 10.0.1.20 80"
            exit 1
        fi
        tunnel_host "${@:2}"
        ;;
    *)
        echo "Usage: $0 {list|test <host>|tunnel <host> [local_port] [remote_host] [remote_port]}"
        exit 1
        ;;
esac
