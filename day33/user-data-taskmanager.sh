#!/bin/bash

# Use data for Task ManagerDocker deployment

set -e

apt update -y && apt upgrade -y
apt install -y docker.io docker-compose-plugin git

cd /opt
git clone https://github.com/rulesmaaz-spec/taskmanager-docker.git taskmanager
cd taskmanager

docker compose up -d
systemctl enable docker

