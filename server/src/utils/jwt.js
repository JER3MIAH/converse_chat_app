import jwt from 'jsonwebtoken';
import config from '../config/config.js';

const JWT_SECRET = config.JWT_SECRET || 'your_secret_key';

// Function to generate JWT
export const generateToken = (user) => {
    return jwt.sign({ id: user._id }, JWT_SECRET, /*{ expiresIn: '1h' }*/);
};
