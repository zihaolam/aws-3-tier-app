from typing import List, Optional, Union
from models import Post
from flask import abort
from db import db

def create(user: dict) -> Post:
    new_post = Post(**user)
    db.session.add(new_post)
    db.session.commit()
    return new_post


def update(user_id: int, updated_post: dict) -> Post:
    Post.query.filter_by(id=user_id).update(updated_post)
    db.session.commit()

    return Post.query.filter_by(id=user_id).first()

def find(user_id: Optional[int] = None) -> Union[dict, List[dict]]:
    if user_id is not None:
        user_found: Post = Post.query.filter_by(id=user_id).first()
        if user_found is None:
            return abort(code=422)
                
        return user_found.to_json()
    
    _posts: List[Post] = Post.query.all()
    return [_post.to_json() for _post in _posts]


def delete(post_id: int):
    post_to_delete = Post.query.filter_by(id=post_id).first()
    if post_to_delete is None:
        return abort(code=422)
    
    db.session.delete(post_to_delete)
    db.session.commit()
    