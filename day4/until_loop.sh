#!/bin/bash

# Wait until a service is up
echo "Waiting for nginx to start..."
until systemctl is active --quiet nginx 2>/dev/null; do
      echo "Still waiting..."
      sleep 1
done
echo "nginx is now running"

