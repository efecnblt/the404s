const express = require('express');
const mysql = require('mysql2/promise');
const cors = require('cors');
const admin = require('firebase-admin');

const app = express();
app.use(cors());
app.use(express.json());

// Firebase Admin SDK initialization
admin.initializeApp({
    credential: admin.credential.cert(require("D:\cyberguard-87d6e-firebase-adminsdk-pog42-122ceffc2d.json"))
});

const pool = mysql.createPool({
    host: 'localhost:3306',
    user: 'root',
    password: 'softwareProject123?',
    database: 'CyberGuard',
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

// Middleware to verify Firebase token
const verifyToken = async (req, res, next) => {
    const token = req.headers.authorization?.split('Bearer ')[1];
    try {
        const decodedToken = await admin.auth().verifyIdToken(token);
        req.user = decodedToken;
        next();
    } catch (error) {
        res.status(401).send('Unauthorized');
    }
};

// Get user's courses
app.get('/user/courses', verifyToken, async (req, res) => {
    try {
        const [rows] = await pool.query('SELECT * FROM Courses WHERE author_id = ?', [req.user.uid]);
        res.json(rows);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Get all courses
app.get('/courses', verifyToken, async (req, res) => {
    try {
        const [rows] = await pool.query('SELECT * FROM Courses');
        res.json(rows);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});