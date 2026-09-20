#!/usr/bin/env python3
"""System information gathering module."""

import os
import socket
from typing import Dict, Optional

def get_memory_info() -> Dict[str, str]:
    """Return memory total, used, available as strings."""
    try:
        import psutil
        mem = psutil.virtual_memory()
        return {
            "total": format_bytes(mem.total),
            "used": format_bytes(mem.used),
            "available": format_bytes(mem.available),
            "percent": f"{mem.percent:.1f}%"
        }
    except ImportError:
        # Fallback: parse /proc/meminfo
        meminfo = {}
        try:
            with open("/proc/meminfo", "r") as f:
                for line in f:
                    parts = line.split(":")
                    if len(parts) == 2:
                        key = parts[0].strip()
                        val = parts[1].strip().split()[0]
                        meminfo[key] = int(val)
            total = meminfo.get("MemTotal", 0) * 1024
            available = meminfo.get("MemAvailable", 0) * 1024
            used = total - available
            return {
                "total": format_bytes(total),
                "used": format_bytes(used),
                "available": format_bytes(available),
                "percent": f"{(used/total)*100:.1f}%" if total else "N/A"
            }
        except Exception:
            return {"error": "Unable to read memory info"}

def get_disk_info(path: str = "/") -> Dict[str, str]:
    """Return disk usage for a given path."""
    try:
        import psutil
        disk = psutil.disk_usage(path)
        return {
            "mount": path,
            "total": format_bytes(disk.total),
            "used": format_bytes(disk.used),
            "free": format_bytes(disk.free),
            "percent": f"{disk.percent:.1f}%"
        }
    except ImportError:
        try:
            stat = os.statvfs(path)
            total = stat.f_frsize * stat.f_blocks
            free = stat.f_frsize * stat.f_bavail
            used = total - free
            return {
                "mount": path,
                "total": format_bytes(total),
                "used": format_bytes(used),
                "free": format_bytes(free),
                "percent": f"{(used/total)*100:.1f}%" if total else "N/A"
            }
        except Exception:
            return {"error": "Unable to read disk info"}

def get_network_info() -> Dict[str, str]:
    """Return hostname and IP address."""
    try:
        hostname = socket.gethostname()
        # Get primary IP (a bit tricky; we'll use a common approach)
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.settimeout(0.1)
        s.connect(("8.8.8.8", 80))
        ip = s.getsockname()[0]
        s.close()
        return {"hostname": hostname, "ip": ip}
    except Exception:
        try:
            hostname = socket.gethostname()
            ip = socket.gethostbyname(hostname)
            return {"hostname": hostname, "ip": ip}
        except Exception:
            return {"error": "Unable to get network info"}

def format_bytes(size_bytes: int) -> str:
    """Convert bytes to human‑readable string."""
    for unit in ("B", "KB", "MB", "GB"):
        if size_bytes < 1024:
            return f"{size_bytes:.1f} {unit}"
        size_bytes /= 1024
    return f"{size_bytes:.1f} TB"
