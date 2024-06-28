"""Todo routes"""

from flask import request, Blueprint
from bson import ObjectId
from app.models import User
from app.config import db


auth_bp = Blueprint('auth_bp', __name__)


@auth_bp.route('/')
def test():
    """Test function"""
    return 'Yooooooooooo'


@auth_bp.route('/sign_up', methods=['POST'])
def sign_up():
    """Sign up function(Creates a user)
    """
    auth_req = User(username=request.json.get('username'),
                    email=request.json.get('email'))


@auth_bp.route('/login', methods=['POST'])
def login():
    """Login function
    """
