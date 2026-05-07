#!/bin/bash
CONFIG_FILE="/etc/nginx/nginx.conf"

if [ -f "$CONFIG_FILE" ]; then
    echo "Yes, Config file exist: $CONFIG_FILE"

    if [ -r "$CONFIG_FILE" ] && [ -w "$CONFIG_FILE" ]; then
        echo "Yes, Config file is readable and writable"
    else
        echo "No, Config file is not readable and writable"
    fi
else
    echo "No config file missing: $CONFIG_FILE"
    echo "Cannot proceed. Exiting"
    exit 1
fi
