#!/bin/bash
set -euo pipefail

# no sapces arount = sign!
name="Mohammad Maaz"
age=20
current_date=$(date +%Y-%m-%d) # Command substitution
current_dir=$(pwd)

# Access variable with $
echo "Hello, my name is $name"
echo "I am $age year old"
echo "Today is: $current_date"
echo "Current directory: $current_dir"

# Currely braces for clearity and edge cases
echo "${name}'s laptop" # works
echo "$name laptop"     # Also works
echo "${name}123"       # Needed- variablename + 123
echo "$name123"         # Wrong: look for variable named 'name123'

