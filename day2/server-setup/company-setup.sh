#!/bin/bash
# Company Server Setup Script
# Author: Mohammad Maaz
# DAte: 03.05.2026
# Purpose: Create user and group structure for Dev, QA and Audit team

set -e # Exit on any error

echo "Creating groups..."
sudo groupadd -f dev_team
sudo groupadd -f qa_team
sudo groupadd -f audit_team

echo "Creating users..."
for user in alice bob; do
    sudo useradd -m -s /bin/bash -G dev_team $user
    echo "$user:password123" | sudo chpasswd
done

for user in charlie; do
    sudo useradd -m -s /bin/bash -G qa_team $user
    echo "$user:password123" | sudo chpasswd
done

sudo useradd -m -s /bin/bash -G audit_team diana
echo "diana:password123" | sudo chpasswd

echo "Creating directories..."
sudo mkdir -p /opt/company/{source_code,test_reports,deployment_logs}
sudo chgrp dev_team /opt/company/source_code
sudo chgrp qa_team /opt/company/test_reports
sudo chgrp dev_team /opt/company/deployment_logs
sudo chmod 770 /opt/company/source_code
sudo chmod 770 /opt/company/test_reports
sudo chmod 775 /opt/company/deployment_logs

echo "Setup complete! Group and user are created succesfully."
