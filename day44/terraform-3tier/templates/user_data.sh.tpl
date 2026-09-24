#!/bin/bash
set -e

# Update system
apt update -y
apt install -y nginx

# Create a dynamic home page
cat > /var/www/html/index.html <<EOF
<html>
<head><title>${project_name}</title></head>
<body>
<h1>Welcome to ${project_name} — ${environment}</h1>
<p>Hostname: $(hostname)</p>
<p>AZ: ${availability_zone}</p>
<p>Deployed at: $(date)</p>
</body>
</html>
EOF

systemctl start nginx
systemctl enable nginx
