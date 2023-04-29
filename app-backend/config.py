import os
from dotenv import load_dotenv

load_dotenv()

DATABASE_URI = os.environ.get("DATABASE_URI") or 'mysql+pymysql://sbuser:sbpass@10.0.3.11:6033/sbtest'
STAGE = os.environ.get("STAGE") or "prod"