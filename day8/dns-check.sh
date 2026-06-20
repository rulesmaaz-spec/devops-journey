#!/bin/bash
#
# Script: dns-check.sh
# Description: Comprehensive DNS health check for a domain
# Author: Mohammad Maaz
# Usage: ./dns-check.sh <domain>
#

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

DOMAIN="${1:-}"
if [[ -z "$DOMAIN" ]]; then
    echo "Usage: $0 <domain>"
    echo "Example: $0 example.com"
    exit 1
fi

# Function to run a check and report
check_record() {
    local description="$1"
    local record_type="$2"
    local domain="$3"
    local expected="${4:-}"  # optional expected value or substring
    local result output status

    echo -n "  [$record_type] $description ... "
    output=$(dig +short "$record_type" "$domain" 2>&1)
    status=$?
    if [ $status -ne 0 ] || [ -z "$output" ]; then
        echo -e "${RED}FAIL${NC} (no record or query failed)"
        return 1
    else
        if [ -n "$expected" ] && ! echo "$output" | grep -q "$expected"; then
            echo -e "${YELLOW}WARN${NC} (expected '$expected', got: $output)"
            return 2
        else
            echo -e "${GREEN}OK${NC} ($output)"
            return 0
        fi
    fi
}

echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}   DNS HEALTH CHECK: $DOMAIN${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""

# 1. Nameserver reachability
echo "Nameservers:"
NS_LIST=$(dig +short NS "$DOMAIN" 2>/dev/null)
if [ -z "$NS_LIST" ]; then
    echo -e "  ${RED}No NS records found! Domain may not exist.${NC}"
    exit 1
fi
echo "$NS_LIST" | while read ns; do
    echo -n "  $ns ... "
    if ping -c1 -W2 "$ns" >/dev/null 2>&1; then
        echo -e "${GREEN}reachable${NC}"
    else
        echo -e "${RED}unreachable${NC}"
    fi
done
echo ""

# 2. A record (website)
check_record "A record (website)" A "$DOMAIN" || true

# 3. www subdomain (CNAME or A)
check_record "www subdomain" CNAME "www.$DOMAIN" || check_record "www subdomain (A)" A "www.$DOMAIN" || true

# 4. MX record (email)
check_record "MX record (email)" MX "$DOMAIN" || true

# 5. TXT record (SPF)
check_record "TXT (SPF)" TXT "$DOMAIN" "v=spf1" || true

# 6. SOA record
check_record "SOA record" SOA "$DOMAIN" || true

# 7. Check if DNSSEC is enabled
echo -n "  DNSSEC validation ... "
DNSSEC_OUTPUT=$(dig +dnssec "$DOMAIN" 2>&1)
if echo "$DNSSEC_OUTPUT" | grep -q "ad"; then
    echo -e "${GREEN}Authenticated (ad flag present)${NC}"
else
    echo -e "${YELLOW}Not authenticated (may be normal)${NC}"
fi

# 8. Query time and resolver
echo ""
echo "Query performance:"
RESOLVER=$(dig "$DOMAIN" | grep "SERVER" | awk '{print $3}' | head -1)
QUERY_TIME=$(dig "$DOMAIN" | grep "Query time" | awk '{print $4}')
echo "  Resolver: $RESOLVER"
echo "  Query time: ${QUERY_TIME} ms"

echo ""
echo -e "${CYAN}========================================${NC}"
echo "Check complete."
