import jwt from "jsonwebtoken";
import config from "../config/config.js";

export const authMiddleware = (req, res, next) => {
    const token = req.headers['authorization']?.split(' ')[1];
    if (!token) {
        return res.status(401).json({ errorMessage: "Access token required" });
    }

    jwt.verify(token, config.JWT_SECRET, (err, decoded) => {
        if (err) {
            return res.status(403).json({ errorMessage: "Invalid token" });
        }
        req.userId = decoded.id;
        console.log(`User id: ${req.userId}`);
        next();
    });
};
