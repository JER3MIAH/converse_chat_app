"""Todo routes"""


import bcrypt
from flask import request, Blueprint, jsonify
from app.models import User
from app.config import db


auth_bp = Blueprint('auth_bp', __name__)


@auth_bp.route('/')
def test():
    """Test function"""
    return 'Yooooooooooo'


@auth_bp.route('/sign_up', methods=['POST'])
def sign_up():
    """Sign up function(Creates a user)"""
    data = request.json
    username = data.get('username')
    email = data.get('email')
    password = data.get('password')

    if not username or not email or not password:
        return jsonify({'message': 'Missing fields'}), 400

    existing_user = db.users.find_one({"email": email})
    if existing_user:
        return jsonify({"msg": "User already exists"}), 400

    hashed_password = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())

    new_user = User(
        username=username,
        email=email,
        password=hashed_password.decode('utf-8')
    )

    # Store new user in the database
    db.users.insert_one(new_user.to_dict())

    return jsonify({'message': 'User created successfully', 'data': new_user.to_dict()}), 201


@auth_bp.route('/login', methods=['POST'])
def login():
    """Login function"""
    data = request.json
    email = data.get('email')
    password = data.get('password')

    if not email or not password:
        return jsonify({'message': 'Missing fields'}), 400

    user_data = db.users.find_one({'email': email})

    if not user_data:
        return jsonify({'message': 'User not found'}), 404

    user = User.from_dict(user_data)

    if bcrypt.checkpw(password.encode('utf-8'), user.password.encode('utf-8')):

        return jsonify({'message': 'Logged in successfully', 'data': user.to_dict()}), 200
    else:
        return jsonify({'message': 'Invalid credentials'}), 401

