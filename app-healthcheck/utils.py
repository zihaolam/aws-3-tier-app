import psutil
import socket
import requests
import boto3

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

ec2_resource = boto3.resource('ec2', region="ap-southeast-1")

def get_node_name():
    res = requests.get("http://169.254.169.254/latest/meta-data/instance-id")
    instance_id = res.text
    instances = ec2_resource.instances.filter(InstanceIds=[instance_id])
    if not len(instances):
        return "invalid instance name"
    for tag in instances[0].tags:
        if tag["Key"] == "Name":
            return tag["Value"]

    

def get_utilization():
    # gives a single float value
    return {
        "cpu": psutil.cpu_percent(),
        "memory": 100-(psutil.virtual_memory().available * 100 / psutil.virtual_memory().total),
    }