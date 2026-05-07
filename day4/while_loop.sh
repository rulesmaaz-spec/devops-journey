#!/bin/bash

echo "========== Basic while loop =========="
counter=1
while [ "$counter" -le 5 ]; do
    echo "Iteration: $counter"
    ((counter++))  # Increment counter
done

echo "========== Reading a file line by line (Production pattern) =========="
 cat > servers.txt << 'EOF'
web-server-01
web-server-02
db-sever-01
cache-server01
EOF

while IFS= read -r server; do
      [[ -z "$server" || "$server" =~ ^# ]] && continue

      echo "Procsessing server: $server"
    # In production, you'd SSH here:
    # ssh "$server" "sudo systemctl restart nginx"
 
done < servers.txt

echo "========== Infinite loop with break =========="
count=0
while true; do
      echo "Count: $count"
        ((count++))
    if [ "$count" -ge 5 ]; then
         echo "Breaking out"
          break
        fi
done
