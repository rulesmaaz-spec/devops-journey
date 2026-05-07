#!/bin/bash
set -euo pipefail

# Method 1: read command
echo "What is yor name?"
read username
echo "Assalamualaikum, $username!"

# Method 2: read with prompt
read -p "Enter your age: " age
echo "You are $age year old"

# Method 3: Silent input (for password)
read -sp "Enter password: " password
echo                                      # New line after silent input
echo "Password received (not shown)"     # If you want to show password + '$password'

# Method 4: read with timeout
read -t 5 -p "Quik! Type somthing in five second: " quick_input
echo "You typed ${quick_input:-nothing}"

# Method 5: read multiple value
read -p "Enter first and last name " first last
echo "First name: $first, Second name: $last."

# Method 6: Command line argument (prefered for automation)
echo "Script called with $# arguments"
echo "First argument: ${1:-not provide}"
echo "Second argument: ${2:-not provide}"

