import psutil
import socket

def get_ip():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.settimeout(0)
    try:
        # doesn't even have to be reachable
        s.connect(('10.254.254.254', 1))
        IP = s.getsockname()[0]
    except Exception:
        IP = '127.0.0.1'
    finally:
        s.close()
    return IP


def get_utilization():
    # gives a single float value
    return {
        "cpu": psutil.cpu_percent(),
        "memory": 100-(psutil.virtual_memory().available * 100 / psutil.virtual_memory().total),
    }