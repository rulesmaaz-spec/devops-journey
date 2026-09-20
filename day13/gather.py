#!/usr/bin/env python3
"""System info gatherer — uses the sysinfo module."""

import json
import sys
from datetime import datetime
from sysinfo import get_memory_info, get_disk_info, get_network_info

def gather_all() -> dict:
    """Collect all system info and return as dictionary."""
    data = {
        "timestamp": datetime.now().isoformat(),
        "memory": get_memory_info(),
        "disk": get_disk_info("/"),
        "network": get_network_info()
    }
    # Add CPU if psutil is available
    try:
        import psutil
        data["cpu_percent"] = psutil.cpu_percent(interval=1)
    except ImportError:
        data["cpu_percent"] = "psutil not installed"
    return data

def main():
    output_file = "system_info.json"
    try:
        info = gather_all()
        with open(output_file, "w") as f:
            json.dump(info, f, indent=2)
        print(f"System info saved to {output_file}")
    except Exception as e:
        print(f"Error gathering system info: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()
