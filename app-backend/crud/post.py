from typing import List, Optional, Union
from models import Post
from sqlalchemy import select, text, Row, CursorResult
from sqlalchemy.orm import Session
from flask import abort, jsonify
from db import db


IP_ADDRESS_STMT = "(Select SUBSTRING_INDEX(host,':',1) as 'ip' From information_schema.processlist WHERE ID=connection_id()) ip_records"
def get_posts_stmt(where: Optional[str] = None):
    return f"select * from posts join {IP_ADDRESS_STMT} {'' if where is None else 'where ' + where};"



def update(post_id: int, updated_post: Row) -> Post:
    Post.query.filter_by(id=post_id).update(updated_post)
    db.session.commit()

    return Post.query.filter_by(id=post_id).first()

def find_all() -> CursorResult:
    res = db.session.execute(text(get_posts_stmt()))
    return res

def find_one(post_id: int) -> Row:
    res = db.session.execute(text(get_posts_stmt(f"posts.id = {post_id}"))).fetchone()
    if res is None:
        return abort(code=422)
            
    return res

def create(post: Row) -> Row:
    new_post = Post(**post)
    db.session.add(new_post)
    db.session.commit()
    db.session.flush(new_post)
    return find_one(post_id=new_post.id)


def delete(post_id: int):
    post_to_delete = Post.query.filter_by(id=post_id).first()
    if post_to_delete is None:
        return abort(code=422)
    
    db.session.delete(post_to_delete)
    db.session.commit()