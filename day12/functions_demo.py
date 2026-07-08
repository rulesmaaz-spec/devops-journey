#!/usr/bin/env python3
"""Demo of well‑structured functions with type hints."""

import os
from typing import Dict, List, Optional

def get_cpu_usage() -> Optional[float]:
    """
    Return current CPU usage as a percentage.
    Returns None if unable to determine.
    """
    try:
        import psutil
        return psutil.cpu_percent(interval=1)
    except ImportError:
        # Fallback: parse /proc/stat
        try:
            with open("/proc/stat", "r") as f:
                fields = f.readline().split()
                # crude calculation; not as accurate as psutil
                idle = float(fields[4])
                total = sum(float(x) for x in fields[1:])
                return 100.0 * (1 - idle / total)
        except Exception:
            return None

def format_bytes(size_bytes: int) -> str:
    """Convert bytes to human‑readable string."""
    for unit in ("B", "KB", "MB", "GB"):
        if size_bytes < 1024:
            return f"{size_bytes:.1f} {unit}"
        size_bytes /= 1024
    return f"{size_bytes:.1f} TB"

if __name__ == "__main__":
    cpu = get_cpu_usage()
    if cpu is not None:
        print(f"CPU usage: {cpu:.1f}%")
    else:
        print("Could not determine CPU usage.")
