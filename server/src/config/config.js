const config = {
    PORT: process.env.PORT || 3000,
    JWT_SECRET: process.env.JWT_SECRET || 'your_default_jwt_secret',
    DATABASE_URL: process.env.DATABASE_URL || 'your_mongodb_url',
};

export default config;