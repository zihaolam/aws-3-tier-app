import logging
import os
import psutil
import socket
import asyncio
import aiohttp
from aiohttp import ClientSession, ClientConnectorError
import async_timeout

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

async def fetch_health(url: str, session: ClientSession, **kwargs) -> tuple:
    try:
        resp = await session.request(method="GET", url=url, **kwargs)
    except ClientConnectorError:
        return (url, 404)
    return (url, resp.status)


node_mapping = {}


async def async_fetch(url):
    try:
        async with aiohttp.ClientSession() as session, async_timeout.timeout(2):
            async with session.get(url) as response:
                json_response = await response.json()
                node_mapping[url] = json_response["node_name"]
                return json_response
    
    except Exception as e:
        logging.error(e)
        return {
            "node_name": node_mapping[url],
            "utilization": {
                "cpu": -1,
                "memory": -1,
            }
        }

        
loop = asyncio.get_event_loop()

def get_all_nodes_health():
    node_ips = ["10.0.3.10", "10.0.4.10", "10.0.5.10", "10.0.3.11", "10.0.3.80", "10.0.4.80", "10.0.1.11", "10.0.1.10", "10.0.3.100", "10.0.4.100", "10.0.3.120", "10.0.4.120", "10.0.1.45", "10.0.1.46", "10.0.2.11", "10.0.2.10"]
    return loop.run_until_complete(asyncio.gather(*[async_fetch(f"http://{node_ip}:8020/health") for node_ip in node_ips]))