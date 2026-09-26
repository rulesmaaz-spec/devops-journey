#!/bin/bash
set -e
apt update -y
apt install -y nginx
cat > /var/www/html/index.html <<EOF
<h1>Modular app — ${server_name} — ${environment}</h1>
EOF
systemctl start nginx
systemctl enable nginx