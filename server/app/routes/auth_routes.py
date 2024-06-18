"""Todo routes"""

from flask import request, Blueprint
# from bson import ObjectId
from models import User
from config.config import db

auth_bp = Blueprint('auth_bp', __name__)


@auth_bp.route('/sign_up', methods=['POST'])
def sign_up():
    """Sign up function
    """
    auth_req = User(username=request.json.get('username'),
                    email=request.json.get('email'))


@auth_bp.route('/login', methods=['POST'])
def login():
    """Login function
    """
