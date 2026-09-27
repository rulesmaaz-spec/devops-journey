#!/bin/bash
set -e
apt update -y
apt install -y nginx

cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${project_name}</title>
</head>
<body>
    <h1>Environment: ${environment}</h1>
    <h2>Server: ${server_name}</h2>
    <p>Deployed by Terraform composite module</p>
</body>
</html>
EOF

systemctl start nginx
systemctl enable nginx
