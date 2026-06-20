#!/bin/bash
#
# Script: subnet-calc.sh
# Description: Calculate subnet details from IP/CIDR
# Author: Mohammad Maaz
# Usage: ./subnet-calc.sh <ip/cidr>
# Example: ./subnet-calc.sh 192.168.1.100/24
#

set -euo pipefail

# Colors
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

# Check if sipcalc is installed
if ! command -v sipcalc >/dev/null 2>&1; then
    echo "Error: 'sipcalc' is required. Install with: sudo apt install sipcalc -y"
    exit 1
fi

# Validate input
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <ip/cidr>"
    echo "Example: $0 10.0.1.0/24"
    exit 1
fi

INPUT="$1"

# Basic format check (must contain a /)
if [[ ! "$INPUT" =~ / ]]; then
    echo "Error: Input must be in CIDR notation (e.g., 192.168.1.0/24)"
    exit 1
fi

echo -e "${CYAN}================================${NC}"
echo -e "${CYAN}   SUBNET CALCULATOR${NC}"
echo -e "${CYAN}================================${NC}"
echo "Input: $INPUT"
echo ""

# Run sipcalc and capture output
SIP_OUTPUT=$(sipcalc "$INPUT" 2>&1)

if echo "$SIP_OUTPUT" | grep -q "ERR"; then
    echo "Error: Invalid input or sipcalc error."
    echo "$SIP_OUTPUT"
    exit 1
fi

# Extract fields – use '|| true' so the script doesn't exit if a pattern is missing
HOST_ADDRESS=$(echo "$SIP_OUTPUT" | grep "Host address" | awk '{print $4}' || true)
NETWORK=$(echo "$SIP_OUTPUT" | grep "Network address" | awk '{print $4}' || true)
NETMASK=$(echo "$SIP_OUTPUT" | grep "Network mask" | awk '{print $4}' || true)
NETMASK_BITS=$(echo "$SIP_OUTPUT" | grep "Network mask (bits)" | awk '{print $5}' || true)
BROADCAST=$(echo "$SIP_OUTPUT" | grep "Broadcast address" | awk '{print $4}' || true)

# Correctly extract the full usable range (e.g., "192.168.0.1 - 192.168.255.254")
USABLE_RANGE=$(echo "$SIP_OUTPUT" | grep "Usable range" | awk '{print $4, $5, $6}' || true)

CLASS=$(echo "$SIP_OUTPUT" | grep "Class" | head -1 | awk '{print $2}' || true)
IS_PRIVATE=$(echo "$SIP_OUTPUT" | grep "Private" | awk '{print $2}' || true)

# Compute total number of addresses from the prefix length
if [[ -n "$NETMASK_BITS" ]]; then
    TOTAL_ADDRS=$((2 ** (32 - NETMASK_BITS)))
else
    TOTAL_ADDRS="N/A"
fi

# Display results
echo -e "${GREEN}Host Address:${NC}      ${HOST_ADDRESS:-N/A}"
echo -e "${GREEN}Network:${NC}           ${NETWORK:-N/A}"
echo -e "${GREEN}Subnet Mask:${NC}       ${NETMASK:-N/A}  (/${NETMASK_BITS:-?})"
echo -e "${GREEN}Broadcast:${NC}         ${BROADCAST:-N/A}"
echo -e "${GREEN}Usable Range:${NC}      ${USABLE_RANGE:-N/A}"
echo -e "${GREEN}Address Class:${NC}     ${CLASS:-N/A}"
echo -e "${GREEN}Private Network:${NC}   ${IS_PRIVATE:-No}"
echo -e "${GREEN}Total Addresses:${NC}   $TOTAL_ADDRS"
echo ""
echo -e "${CYAN}================================${NC}"
