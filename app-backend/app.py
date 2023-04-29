from flask import Flask
from flask_migrate import Migrate
from flask_sqlalchemy import SQLAlchemy
from utils import get_all_nodes_health 
from flask_cors import CORS 
from gevent.pywsgi import WSGIServer 
import logging
import config
from routes.post import post_blueprint
from db import db

logging.basicConfig(level=logging.INFO)
 
def create_app():
    app_instance = Flask(__name__) 
    app_instance.config['SQLALCHEMY_DATABASE_URI'] = config.DATABASE_URI
    app_instance.register_blueprint(post_blueprint)
    db.init_app(app_instance)
    return app_instance

app = create_app()
cors = CORS(app)
migrate = Migrate(app, db)
 

@app.route("/ping", methods=["GET"]) 
def ping(): 
    return "pong" 
 
@app.route("/all-health", methods=["GET"]) 
def health(): 
    return get_all_nodes_health()
 
if __name__ == "__main__": 
    if config.STAGE == "prod":
        logging.info(f"Server starting at port 80")
        http_server = WSGIServer(('0.0.0.0', 80), app) 
        http_server.serve_forever()
    else:
        app.run(debug=True, port=8040)