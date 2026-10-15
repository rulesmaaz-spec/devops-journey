#!/usr/bin/env python3
"""
Log Parser: analyse nginx access logs
Usage: python3 log_parser.py <logfile>
"""

import sys
from collections import Counter

def parse_line(line):
    """Extract IP, method, endpoint, status, size from a log line."""
    parts = line.split()
    if len(parts) < 9:
        return None
    ip = parts[0]
    # The request is inside quotes: "GET /path HTTP/1.1"
    # Find the opening quote
    try:
        req_start = line.index('"') + 1
        req_end = line.index('"', req_start)
        request = line[req_start:req_end]
        method, path, _ = request.split()
    except (ValueError, IndexError):
        return None
    status = int(parts[8])
    size = parts[9] if parts[9] != '-' else 0
    try:
        size = int(size)
    except ValueError:
        size = 0
    return {
        "ip": ip,
        "method": method,
        "endpoint": path,
        "status": status,
        "size": size
    }

def classify_status(code):
    if 200 <= code < 300:
        return "2xx"
    elif 300 <= code < 400:
        return "3xx"
    elif 400 <= code < 500:
        return "4xx"
    else:
        return "5xx"

def analyze_log(filename):
    total = 0
    status_counts = Counter()
    endpoints = Counter()
    ips = Counter()
    total_size = 0
    errors_4xx = 0
    errors_5xx = 0

    with open(filename, "r") as f:
        for line in f:
            parsed = parse_line(line)
            if parsed is None:
                continue
            total += 1
            status = parsed["status"]
            status_counts[classify_status(status)] += 1
            endpoints[parsed["endpoint"]] += 1
            ips[parsed["ip"]] += 1
            total_size += parsed["size"]
            if 400 <= status < 500:
                errors_4xx += 1
            elif status >= 500:
                errors_5xx += 1

    if total == 0:
        print("No valid log entries found.")
        return

    print("=" * 60)
    print("  LOG ANALYSIS REPORT")
    print("=" * 60)
    print(f"  Total Requests: {total}")
    print(f"  Total Data Transferred: {total_size} bytes")
    error_rate = ((errors_4xx + errors_5xx) / total) * 100
    print(f"  Error Rate: {error_rate:.1f}%")
    print()

    print("  Status Code Distribution:")
    for cat in ["2xx", "3xx", "4xx", "5xx"]:
        count = status_counts.get(cat, 0)
        bar = "#" * (count // 5)  # simple bar
        print(f"    {cat}: {count:4d} {bar}")
    print()

    print("  Top 5 Endpoints:")
    for ep, count in endpoints.most_common(5):
        print(f"    {count:4d}  {ep}")
    print()

    print("  Top 5 Client IPs:")
    for ip, count in ips.most_common(5):
        print(f"    {count:4d}  {ip}")
    print("=" * 60)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 log_parser.py <logfile>")
        sys.exit(1)
    analyze_log(sys.argv[1])
