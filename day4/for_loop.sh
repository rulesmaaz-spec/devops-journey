#!/bin/bash

# USED ONLY WHEN YOU KNOW THE COUNT OR POSSIBLE OUTPUT/DESIRED OUTPUT

echo "========== Iterating over a list =========="
for fruit in apple banana cherry dates orange; do
       echo "I love $fruit"
done

echo "\n========= Iterating over numbers =========="
for i in {1..5}; do
       echo "Number: $i"
done

echo "\n========== C-style for loop =========="
for (( i=0; i<5; i++)); do
      echo "Count: $i"
done

echo "\n========== Iterating over command output =========="
for user in $(cut -d: -f1 /etc/passwd | head -5); do
     echo "User: $user"
done

echo "\n========= Iterating over files (wild card) =========="
for file in /etc/*.conf; do
       echo "Configration file: $file"
done | head -7                   # Only show first 7
