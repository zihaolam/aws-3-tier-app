from flask import Flask
from utils import get_ip, get_utilization

app = Flask(__name__)


@app.route("/ping", methods=["GET"])
def ping():
    return "pong"

@app.route("/health", methods=["GET"])
def health():
    return {
        "private_ip":get_ip(),
        "utilization": get_utilization()
    }

if __name__ == "__main__":
    from gevent.pywsgi import WSGIServer
    http_server = WSGIServer(('0.0.0.0', 8030), app)
    http_server.serve_forever()