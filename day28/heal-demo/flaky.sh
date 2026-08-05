#!/bin/sh
# Simulate an app that crashes after a random time
echo "Starting flaky app..."
sleep 10   # time to become healthy
# Randomly exit with error after 20-30 seconds
sleep 15
exit 1
