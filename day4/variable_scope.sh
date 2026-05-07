#!/bin/bash
# By default, variable are GLOBAL in a script
global_var="I am global"

my_function() {
    local local_var="I an local to this function"
    echo "Inside function: $global_var"  # Works
    echo "Inside function: $local_var"   # Works
}

echo "Outside function: $global_var"     # Works
echo "Outside function: $local_var"      # Didn't work
