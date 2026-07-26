#!/usr/bin/env python3
import os
import time

print("Hello from inside a cotntainer")
print(f"Container hostname: {os.uname().nodename}")
print("Sleeping 60 seconds so you can inspect the conatainer...")
time.sleep(60)
