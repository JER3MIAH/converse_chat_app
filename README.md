# Converse

A simple real-time chat application built with **Flutter** for the frontend and **Node.js/Express** for the backend. This application supports user authentication, real-time messaging, and chat management.

## Features

- **User Authentication**:
  - Users can register and log in securely using JWT (JSON Web Token).
  - Supports token-based authentication for accessing chat-related functionalities.
- **Real-Time Messaging**:
  - Real-time messaging between users using **Socket.IO**.
  - Notifications for new messages, even when users are not actively in the chat screen.
- **Chat Management**:
  - Users can create, view, and delete chats.
  - Users can archive or unarchive chats.
  - Each user can only see their own chats and messages.
- **Profile Management**:
  - Users can view and update their profile information.
- **Error Handling**:
  - Comprehensive error handling for validation, authentication, and server errors.

## Tech Stack

- **Frontend**: Flutter
- **Backend**: Node.js, Express
- **Database**: MongoDB
- **Authentication**: JWT (JSON Web Token)
- **Real-Time Communication**: Socket.IO

## Prerequisites

- [Node.js](https://nodejs.org/) and npm installed
- [MongoDB](https://www.mongodb.com/) installed or a MongoDB cloud URI
- [Flutter](https://flutter.dev/) installed

## Getting Started

### Backend (Server)

1. **Clone the Repository**

   ```bash
   git clone https://github.com/JER3MIAH/converse_chat_app.git
   cd converse_chat_app/server
   ```

2. **Install Dependencies**

   ```bash
   npm install
   ```

3. **Set up Environment Variables**
   Set your environment variables as follows:

   For Bash:

   ```bash
   export DATABASE_URL="your_mongodb_uri"
   export JWT_SECRET="your_jwt_secret"
   export PORT=5050
   ```

   For PowerShell:

   ```powershell
   $env:DATABASE_URL="your_mongodb_uri"
   $env:JWT_SECRET="your_jwt_secret"
   $env:PORT=5050
   ```

4. **Run Server**

   ```bash
   npm start
   ```

### Frontend (Client)

1. **Clone the Repository**

   ```bash
   git clone https://github.com/JER3MIAH/converse_chat_app.git
   cd converse_chat_app/client
   ```

2. **Install Dependencies**

   ```bash
   flutter pub get
   ```

3. **Set up API URL**

   - Navigate to `client/lib/src/core/network/api_endpoints.dart`.
   - Update the IP address where required.

4. **Run the Flutter App**

   ```bash
   flutter run
   ```

## API Endpoints

### User Routes

- **POST /signup**: Register a new user
- **POST /login**: Log in an existing user
- **GET /get-all-users**: Get all users (requires authentication)
- **GET /get-profile**: Get the profile of the logged-in user (requires authentication)
- **PATCH /update-profile**: Update the profile of the logged-in user (requires authentication)
- **DELETE /delete-account**: Delete the user account (requires authentication)

### Chat Routes

- **GET /get-chats**: Get all chats for the logged-in user (requires authentication)
- **PATCH /archive-chats**: Archive or unarchive selected chats (requires authentication)
- **DELETE /delete-chats**: Delete selected chats (requires authentication)
- **DELETE /delete-messages**: Delete selected messages (requires authentication)
- **POST /create-chat**: Create a new chat (requires authentication)
- **GET /get-messages**: Get all messages for a specific chat (requires authentication)

## Real-Time Communication

- **Socket.IO** is used for real-time messaging. The backend listens for incoming messages and emits events to the frontend for immediate message updates.

### Events

- **JOIN_CHAT**: Emit when a user joins a room(chat).
- **SEND_MESSAGE**: Emit when a user sends a new message.
- **RECEIVE_MESSAGE**: Emit when a new message is received by the user.

## Conclusion

This application provides a simple but powerful chat platform with real-time messaging, user authentication, and chat management. It is built with modern technologies to ensure a seamless and secure user experience.
