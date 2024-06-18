"""Configuration module"""

from flask import Flask
from flask_pymongo import pymongo
from app.config.secrets import MONGODB_URI, SECRET_KEY

app = Flask(__name__)
app.config['SECRET_KEY'] = SECRET_KEY


client = pymongo.MongoClient(MONGODB_URI, serverSelectionTimeoutMS=5000)

db = client.db
