import mongoose from 'mongoose';

export const userSchema = new mongoose.Schema({
    username: String,
    email: String,
    avatar: String,
    password: String,
    fcmToken: String,
}, { collection: "users" });

const User = mongoose.model('User', userSchema);

export default User;