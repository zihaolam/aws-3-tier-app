from flask import Flask
from utils import get_ip, get_utilization
from flask_cors import CORS
import os

app = Flask(__name__)
cors = CORS(app)

@app.route("/ping", methods=["GET"])
def ping():
    return "pong"

@app.route("/health", methods=["GET"])
def health():
    return {
        "node_name": os.environ.get("INSTANCE_NAME"),
        "private_ip":get_ip(),
        "utilization": get_utilization()
    }

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8020)