from flask import Flask 
from utils import get_all_nodes_health 
from flask_cors import CORS 
from gevent.pywsgi import WSGIServer 
import logging
logging.basicConfig(level=logging.INFO)
 
 
app = Flask(__name__) 
cors = CORS(app) 
 
@app.route("/ping", methods=["GET"]) 
def ping(): 
    return "pong" 
 
@app.route("/all-health", methods=["GET"]) 
def health(): 
    return get_all_nodes_health()
 
if __name__ == "__main__": 
    http_server = WSGIServer(('0.0.0.0', 80), app) 
    http_server.serve_forever()