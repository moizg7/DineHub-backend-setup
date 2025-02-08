# Food Delivery Backend

This project is a backend API for a food delivery app, built with Node.js, Express, and MongoDB. It handles user registration, authentication, and order management.

## Getting Started

### 1. Set Up the Project

Create a new directory and initialize the project:

npm init -y

### 2. Install Dependencies

Install the necessary packages:

```bash
npm install express mongoose bcryptjs jsonwebtoken dotenv helmet morgan express-rate-limit
```

### 3. Environment Variables

Create a `.env` file in the root directory:

```plaintext
MONGO_URI=mongodb+srv://<username>:<password>@<cluster-address>/<database>?retryWrites=true&w=majority
JWT_SECRET=your_jwt_secret
PORT=5000
```

Replace the placeholders with your MongoDB credentials and a secure JWT secret.

### 4. Start the Server

Run the server using:

```bash
npm start
```

---
