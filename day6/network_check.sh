#!/bin/bash
#
# Script: network-check.sh
# Description: Network diagnostic toolkit
# Author: Mohammad
# Date: 2026-05-23
# Usage: ./network-check.sh [target_host]
#

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

TARGET="${1:-google.com}"
REPORT_FILE="$HOME/devops-journey/day6/network-report-$(date +%Y%m%d-%H%M%S).txt"

# ============================================
# FUNCTIONS
# ============================================

print_header() {
    echo -e "\n${CYAN}========================================${NC}"
    echo -e "${CYAN}  $1${NC}"
    echo -e "${CYAN}========================================${NC}"
}

check_result() {
    if [ $? -eq 0 ]; then
        echo -e "  ${GREEN}✅ PASS${NC}: $1"
        return 0
    else
        echo -e "  ${RED}❌ FAIL${NC}: $1"
        return 1
    fi
}

# ============================================
# TESTS
# ============================================

test_local_network() {
    print_header "LOCAL NETWORK CONFIGURATION"
    
    echo "  Hostname: $(hostname -f 2>/dev/null || hostname)"
    
    # Default gateway
    local gateway
    gateway=$(ip route show default 2>/dev/null | awk '{print $3}' | head -1)
    echo "  Default Gateway: ${gateway:-Not found}"
    
    # DNS servers
    echo "  DNS Servers:"
    grep "nameserver" /etc/resolv.conf 2>/dev/null | awk '{print "    " $2}' || echo "    Cannot read /etc/resolv.conf"
    
    # Local IPs
    echo "  Local IP Addresses:"
    ip -4 addr show 2>/dev/null | grep "inet " | awk '{print "    " $2 " on " $NF}' || echo "    Cannot get IPs"
}

test_internet_connectivity() {
    print_header "INTERNET CONNECTIVITY"
    
    # Ping test
    echo "  Pinging $TARGET..."
    if ping -c 3 -W 2 "$TARGET" >/dev/null 2>&1; then
        local rtt
        rtt=$(ping -c 3 "$TARGET" 2>/dev/null | tail -1 | awk -F'/' '{print $5}')
        echo -e "  ${GREEN}✅${NC} Ping successful (avg RTT: ${rtt:-unknown} ms)"
    else
        echo -e "  ${RED}❌${NC} Ping failed"
    fi
    
    # Path to target
    echo -e "\n  Tracing route to $TARGET..."
    if command -v traceroute >/dev/null 2>&1; then
        traceroute -m 10 "$TARGET" 2>&1 | head -15 | while read -r line; do
            echo "    $line"
        done
    elif command -v tracepath >/dev/null 2>&1; then
        tracepath -m 10 "$TARGET" 2>&1 | head -15 | while read -r line; do
            echo "    $line"
        done
    else
        echo "    traceroute not installed"
    fi
}

test_dns_resolution() {
    print_header "DNS RESOLUTION"
    
    echo "  Resolving $TARGET..."
    
    # A record
    if command -v dig >/dev/null 2>&1; then
        local ip
        ip=$(dig +short "$TARGET" 2>/dev/null | head -1)
        if [ -n "$ip" ]; then
            echo -e "  ${GREEN}✅${NC} A record: $TARGET → $ip"
            echo "  Query time: $(dig "$TARGET" 2>/dev/null | grep "Query time" | awk '{print $4}') ms"
        else
            echo -e "  ${RED}❌${NC} DNS resolution failed"
        fi
        
        # MX record
        echo -e "\n  Mail servers (MX):"
        dig +short "$TARGET" MX 2>/dev/null | head -3 | while read -r line; do
            echo "    $line"
        done || echo "    No MX records found"
        
    else
        # Fallback to nslookup
        if nslookup "$TARGET" >/dev/null 2>&1; then
            echo -e "  ${GREEN}✅${NC} nslookup: $TARGET resolves successfully"
        else
            echo -e "  ${RED}❌${NC} DNS resolution failed"
        fi
    fi
}

test_http_connectivity() {
    print_header "HTTP/HTTPS CONNECTIVITY"
    
    for protocol in "http" "https"; do
        echo "  Testing ${protocol}://${TARGET}..."
        
        local http_code
        http_code=$(curl -o /dev/null -s -w "%{http_code}" --connect-timeout 5 --max-time 10 "${protocol}://${TARGET}" 2>/dev/null || echo "000")
        
        if [ "$http_code" != "000" ]; then
            echo -e "  ${GREEN}✅${NC} HTTP Status: $http_code"
            
            # Show response time
            curl -o /dev/null -s -w "  Connect: %{time_connect}s | TLS: %{time_appconnect}s | TTFB: %{time_starttransfer}s | Total: %{time_total}s\n" \
                --connect-timeout 5 --max-time 10 "${protocol}://${TARGET}" 2>/dev/null
        else
            echo -e "  ${RED}❌${NC} Connection failed"
        fi
        echo ""
    done
}

test_ssl_certificate() {
    print_header "SSL/TLS CERTIFICATE"
    
    echo "  Checking certificate for $TARGET:443..."
    
    local cert_info
    cert_info=$(echo | openssl s_client -connect "${TARGET}:443" -servername "$TARGET" 2>/dev/null | openssl x509 -noout -dates -subject -issuer 2>/dev/null)
    
    if [ -n "$cert_info" ]; then
        echo "$cert_info" | while read -r line; do
            echo "  $line"
        done
        
        # Check expiry
        local expiry_date
        expiry_date=$(echo "$cert_info" | grep "notAfter" | cut -d= -f2)
        local expiry_epoch
        expiry_epoch=$(date -d "$expiry_date" +%s 2>/dev/null || echo 0)
        local now_epoch
        now_epoch=$(date +%s)
        local days_left=$(( (expiry_epoch - now_epoch) / 86400 ))
        
        if [ $days_left -gt 30 ]; then
            echo -e "  ${GREEN}✅${NC} Certificate expires in $days_left days"
        elif [ $days_left -gt 0 ]; then
            echo -e "  ${YELLOW}⚠️${NC}  Certificate expires in $days_left days — RENEW SOON!"
        else
            echo -e "  ${RED}❌${NC} Certificate EXPIRED!"
        fi
    else
        echo -e "  ${RED}❌${NC} Could not retrieve certificate (or target doesn't support HTTPS)"
    fi
}

test_common_ports() {
    print_header "COMMON PORT CHECK"
    
    local ports=("22:SSH" "80:HTTP" "443:HTTPS" "3306:MySQL" "5432:PostgreSQL")
    
    for port_entry in "${ports[@]}"; do
        local port="${port_entry%%:*}"
        local service="${port_entry##*:}"
        
        if timeout 3 bash -c "echo >/dev/tcp/$TARGET/$port" 2>/dev/null; then
            echo -e "  ${GREEN}✅${NC} Port $port ($service) is OPEN"
        else
            echo -e "  ${YELLOW}🔒${NC} Port $port ($service) is CLOSED or filtered"
        fi
    done
}

# ============================================
# MAIN
# ============================================
main() {
    {
        echo "========================================="
        echo "  NETWORK DIAGNOSTIC REPORT"
        echo "========================================="
        echo "Target: $TARGET"
        echo "Date: $(date)"
        echo "========================================="
        
        test_local_network
        test_internet_connectivity
        test_dns_resolution
        test_http_connectivity
        test_ssl_certificate
        test_common_ports
        
        echo ""
        echo "========================================="
        echo "  DIAGNOSTIC COMPLETE"
        echo "  Report: $REPORT_FILE"
        echo "========================================="
    } | tee "$REPORT_FILE"
}

main
