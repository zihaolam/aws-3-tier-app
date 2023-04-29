from sqlalchemy import func
from db import db

class Post(db.Model):
    __tablename__ = "posts"
    id = db.Column(db.Integer, primary_key=True)
    created_by = db.Column(db.String(100), nullable=False)
    content = db.Column(db.TEXT, nullable=False)
    title = db.Column(db.String(1000), nullable=False)

    def __repr__(self):
        return f"Post: {self.title}"
    
    def to_json(self):
        return dict(id=self.id, created_by=self.created_by, content=self.content, title=self.title)