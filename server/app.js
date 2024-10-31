import express from "express";
import mongoose from "mongoose";
import userRoutes from "./src/routes/user-routes.js";
import config from "./src/config/config.js";

const app = express();

app.use(express.urlencoded({ extended: true }));
app.use(express.json());

mongoose.connect(config.DATABASE_URL);

app.use('/api/user', userRoutes);

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

export default app;