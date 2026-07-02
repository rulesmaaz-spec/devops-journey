#!/bin/bash
#
# Script: ssl-check.sh
# Description: Check SSL/TLS certificate for a domain
# Author: Mohammad Maaz
# Usage: ./ssl-check.sh <domain> [port]
#

set -euo pipefail

DOMAIN="${1:-}"
PORT="${2:-443}"
WARNING_DAYS=30
CRITICAL_DAYS=14

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

if [[ -z "$DOMAIN" ]]; then
    echo "Usage: $0 <domain> [port]"
    echo "Example: $0 example.com 443"
    exit 1
fi

echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}   SSL CERTIFICATE CHECK${NC}"
echo -e "${CYAN}========================================${NC}"
echo "Domain: $DOMAIN:$PORT"
echo ""

# Fetch certificate info using openssl s_client
CERT_INFO=$(echo | openssl s_client -connect "${DOMAIN}:${PORT}" -servername "$DOMAIN" 2>/dev/null)
if [[ $? -ne 0 ]] || [[ -z "$CERT_INFO" ]]; then
    echo -e "${RED}Error: Could not connect or retrieve certificate.${NC}"
    exit 1
fi

# Extract certificate
CERT=$(echo "$CERT_INFO" | openssl x509 -noout -text 2>/dev/null)
if [[ -z "$CERT" ]]; then
    echo -e "${RED}Error: Failed to parse certificate.${NC}"
    exit 1
fi

# Subject and Issuer
SUBJECT=$(echo "$CERT_INFO" | openssl x509 -noout -subject 2>/dev/null | sed 's/^subject=//')
ISSUER=$(echo "$CERT_INFO" | openssl x509 -noout -issuer 2>/dev/null | sed 's/^issuer=//')
echo -e "${GREEN}Subject:${NC} $SUBJECT"
echo -e "${GREEN}Issuer:${NC}  $ISSUER"

# Validity dates
START_DATE=$(echo "$CERT_INFO" | openssl x509 -noout -startdate 2>/dev/null | cut -d= -f2)
END_DATE=$(echo "$CERT_INFO" | openssl x509 -noout -enddate 2>/dev/null | cut -d= -f2)
echo -e "${GREEN}Valid from:${NC} $START_DATE"
echo -e "${GREEN}Valid until:${NC} $END_DATE"

# Calculate days until expiry
if date --version >/dev/null 2>&1; then
    # GNU date
    END_EPOCH=$(date -d "$END_DATE" +%s 2>/dev/null)
else
    # BSD/macOS date
    END_EPOCH=$(date -j -f "%b %d %T %Y %Z" "$END_DATE" +%s 2>/dev/null)
fi

NOW_EPOCH=$(date +%s)
DAYS_LEFT=$(( (END_EPOCH - NOW_EPOCH) / 86400 ))

echo -n "Days until expiry: "
if [[ $DAYS_LEFT -le $CRITICAL_DAYS ]]; then
    echo -e "${RED}$DAYS_LEFT (CRITICAL — renew immediately!)${NC}"
elif [[ $DAYS_LEFT -le $WARNING_DAYS ]]; then
    echo -e "${YELLOW}$DAYS_LEFT (Warning — renew soon)${NC}"
else
    echo -e "${GREEN}$DAYS_LEFT${NC}"
fi

# Check Subject Alternative Names (SANs)
echo ""
echo -e "${GREEN}Subject Alternative Names:${NC}"
echo "$CERT" | grep -A1 "Subject Alternative Name" | tail -1 | tr ',' '\n' | sed 's/DNS://g' | while read san; do
    echo "  - ${san## }"
done

# Check if certificate is self-signed
if [[ "$SUBJECT" == "$ISSUER" ]]; then
    echo -e "${YELLOW}Warning: Certificate appears to be self-signed.${NC}"
fi

# Test TLS versions
echo ""
echo "TLS Version Support:"
for version in "-tls1_2" "-tls1_3"; do
    if echo | openssl s_client -connect "${DOMAIN}:${PORT}" $version -servername "$DOMAIN" 2>/dev/null | grep -q "CONNECTED"; then
        echo -e "  ${version#-}: ${GREEN}Supported${NC}"
    else
        echo -e "  ${version#-}: ${RED}Not supported${NC}"
    fi
done

echo ""
echo -e "${CYAN}========================================${NC}"
echo "Check complete."
