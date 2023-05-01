from flask import Blueprint, request
from crud import post
from utils import get_ip

post_blueprint = Blueprint('post_route', __name__,url_prefix="/post")

my_ip = get_ip()

@post_blueprint.route('/<post_id>', methods=["GET"])
def post_blueprint_read_one_handler(post_id: int):
    _post =  post.find_one(post_id)
    return {**_post._asdict(), "backend_ip": my_ip}

@post_blueprint.route("/", methods=["GET"])
def post_blueprinter_read_all_handler():
    _posts = post.find_all()
    return [{**_post._asdict(), "backend_ip": my_ip} for _post in _posts]

@post_blueprint.route("/", methods=["POST"])
def post_blueprinter_create_handler():
    new_post = post.create(request.json)
    return {**new_post._asdict(), "backend_ip": my_ip}


@post_blueprint.route("/<post_id>", methods=["PUT"])
def post_blueprint_update_handler(post_id: str):
    updated_post = post.update(int(post_id), request.json)
    return {**updated_post._asdict(), "backend_ip": my_ip}

@post_blueprint.route("/<post_id>", methods=["DELETE"])
def post_blueprint_delete_handler(post_id: int):
    post.delete(post_id)

    return "Delete success"