#!/bin/bash
set -eou pipefail

# Basic if-else
read -p "Enter a number: " num

if [ "$num" -gt 10 ]; then
    echo "$num is greater 10"

elif [ "$num" -ge 10 ]; then
      echo "$num is equal to 10"
else
      echo "$num is less then 10"
fi
# 'fi' closes if block
# Spaces mendetory inside brackets []
