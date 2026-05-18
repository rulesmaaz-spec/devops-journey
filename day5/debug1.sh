#!/bin/bash
set -euo pipefail

echo "this part run normally"

#Enable debug for this section only

set -x
problematic_function() {
    local x=5
    local y=10
    local result=$(( x * y ))
    echo "Result: $result"
}
problematic_function

set -x

echo "debugging section complete"

