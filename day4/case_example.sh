#!/bin/bash

read -p "Enter service to manage (nginx/mysql/ssh): " service

case "$service" in
    nginx)
       echo "Managing Nginix"
       echo "Status: $(sytemctl is-active nginx 2>/dev/null || echo 'not installed')"
       ;;
    mysql|postgresql)
       echo "Managing Database..."
       echo "This is a critical service!"
       ;;
    ssh)
      echo "Managing SSH..."
      echo "Warning: Don't lock yourself out!"
      ;;
    *)
      echo "Unknown service: $service"
      echo "Availiable: nginx, mysql, postgresql, ssh"
      ;;
esac
