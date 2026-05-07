#!/bin/bash
# String variables
geeeting="Assalamu alaikum"
file_path="/etc/nginx.nginix.conf"

# Integer variables
count=10
price=999

# Array's (Bash 4+)
fruits=("dates" "banana" "orange" "apple")
echo "First fruit: ${fruits[0]}"       # Showed by index number
echo "All fruits: ${fruits[@]}"        # show all in array
echo "NUmber of fruits ${#fruits[@]}"  # count index

# Associative array (like dictionaries)
declare -A user
user[name]="Mohammad Maaz"
user[role]="DevOps Engineer"
user[location]="Dubai"
echo "Name: ${user[name]}"
echo "Role: ${user[role]}"

# Read only variables (constant)
readonly COMPANY="TechCorp"
readonly MAX_RETRIES=3
