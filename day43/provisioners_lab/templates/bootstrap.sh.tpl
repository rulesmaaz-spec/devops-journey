#!/bin/bash
set -e

# Update system
apt update -y

# Install nginx
apt install -y nginx

# Create a dynamic home page
cat > /var/www/html/index.html <<EOF
<html>
<head><title>${project_name}</title></head>
<body>
<h1>Hello from ${environment}!</h1>
<p>Backend IP: ${backend_ip}</p>
<p>Deployed at: $(date)</p>
</body>
</html>
EOF

# Start nginx
systemctl start nginx
systemctl enable nginx
