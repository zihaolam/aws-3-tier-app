from flask_migrate import Migrate
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import text

db = SQLAlchemy()

if __name__ == "__main__":
    from app import app
    with app.app_context():
        try:
            # db.session.execute('SELECT 1')
            db.session.execute(text('SELECT 1'))
            print('\n\n----------- Connection successful !')
        except Exception as e:
            print('\n\n----------- Connection failed ! ERROR : ', e)