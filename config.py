from flask import Flask
import os
from flask_sqlalchemy import SQLAlchemy


app = Flask(__name__)
app.secret_key = os.urandom(24)
app.config['SQLALCHEMY_DATABASE_URI']='mysql+pymysql://root@localhost/online_exam_db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)


