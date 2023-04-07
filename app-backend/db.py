from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import text
from app import app

def setup(app: Flask):
    app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://sbuser:sbpass@10.0.3.11:6033/sbtest'
    return SQLAlchemy(app)


db = setup(app)

with app.app_context():
    try:
        # db.session.execute('SELECT 1')
        db.session.execute(text('SELECT 1'))
        print('\n\n----------- Connection successful !')
    except Exception as e:
        print('\n\n----------- Connection failed ! ERROR : ', e)