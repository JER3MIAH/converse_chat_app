import express from "express";
import http from "http"
import { Server } from "socket.io";
import mongoose from "mongoose";
import userRoutes from "./src/routes/user-routes.js";
import chatRoutes from "./src/routes/chat-routes.js";
import config from "./src/config/config.js";

const app = express();
export const server = http.createServer(app);
export const io = new Server(server, {
    cors: { origin: "*" }
});

app.use(express.urlencoded({ extended: true }));
app.use(express.json());

mongoose.connect(config.DATABASE_URL)
    .then(() => console.log("Connected to MongoDB"))
    .catch((error) => console.error("MongoDB connection error:", error));

app.use('/api/user', userRoutes);
app.use('/api/chat', chatRoutes);

app.use((req, res, next) => {
    res.status(404).json({
        success: false,
        statusCode: 404,
        message: `Cannot ${req.method} ${req.originalUrl}`,
    });
});


app.get('/', (req, res) => {
    res.send('Hi there');
});
