#!/usr/bin/env python3
"""Generate a sample nginx access log for testing."""

import random
from datetime import datetime, timedelta

ips = ["192.168.1.10", "10.0.0.5", "172.16.0.20", "192.168.1.100", "10.0.1.99"]
methods = ["GET", "POST", "PUT", "DELETE"]
endpoints = ["/api/users", "/api/health", "/api/orders", "/login", "/static/style.css",
             "/api/products", "/api/checkout", "/admin"]
statuses = [200]*60 + [201]*10 + [301]*5 + [400]*5 + [401]*3 + [403]*2 + [404]*10 + [500]*5
user_agents = ["Mozilla/5.0", "curl/7.68.0", "Python-urllib/3.9", "PostmanRuntime/7.28"]

with open("access.log", "w") as f:
    base_time = datetime.now() - timedelta(hours=1)
    for i in range(500):
        ip = random.choice(ips)
        method = random.choice(methods)
        endpoint = random.choice(endpoints)
        status = random.choice(statuses)
        size = random.randint(50, 5000)
        ua = random.choice(user_agents)
        timestamp = base_time + timedelta(seconds=i*10)
        ts_str = timestamp.strftime("%d/%b/%Y:%H:%M:%S +0000")
        log_line = f'{ip} - - [{ts_str}] "{method} {endpoint} HTTP/1.1" {status} {size} "-" "{ua}"'
        f.write(log_line + "\n")

print("Generated access.log with 500 lines")
