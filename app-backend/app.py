from flask import Flask
from utils import get_all_nodes_health
from flask_cors import CORS

app = Flask(__name__)
cors = CORS(app)

@app.route("/ping", methods=["GET"])
def ping():
    return "pong"

@app.route("/all-health", methods=["GET"])
def health():
    return get_all_nodes_health()

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80)