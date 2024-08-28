const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const nodemailer = require('nodemailer');
const cors = require('cors'); // Import CORS
const User = require('./User'); // Import the User model

const app = express();
const port = 3000;

// Middleware
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(cors()); // Enable CORS

// Connect to MongoDB
mongoose.connect('mongodb://localhost:27017/myapp', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
  .then(() => console.log('MongoDB connected'))
  .catch(err => console.error('MongoDB connection error:', err));

// JWT secret key
const JWT_SECRET = 'your_jwt_secret_key'; // Change this to a secure key

// Function to validate password
const validatePassword = (password) => {
  const passwordRegex = /^(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$/;
  return passwordRegex.test(password);
};

// Register route
app.post('/register', async (req, res) => {
  const { name, email, password } = req.body;

  // Validate password format
  if (!validatePassword(password)) {
    return res.status(400).json({ success: false, message: 'Password must be at least 8 characters long, start with a capital letter, and contain at least one number.' });
  }

  try {
    // Check if user already exists
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ success: false, message: 'Email already registered' });
    }

    // Hash the password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create a new user
    const newUser = new User({ name, email, password: hashedPassword });
    await newUser.save(); // Insert user into MongoDB

    res.status(201).json({ success: true, message: 'User registered successfully' });
  } catch (error) {
    console.error('Error in /register:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

// Login route
app.post('/login', async (req, res) => {
  const { email, password } = req.body;
  try {
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ success: false, message: 'Invalid email or password' });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ success: false, message: 'Invalid email or password' });
    }

    // Generate a JWT token
    const token = jwt.sign({ id: user._id }, JWT_SECRET, { expiresIn: '1h' });

    res.json({ success: true, name: user.name, token });
  } catch (error) {
    console.error('Error in /login:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

// Password reset route
app.post('/reset-password', async (req, res) => {
  const { email } = req.body;
  try {
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ success: false, message: 'Email not found' });
    }

    // Generate a password reset token (for simplicity, use a random token here)
    const resetToken = Math.random().toString(36).substr(2, 10);
    const resetTokenExpiry = Date.now() + 3600000; // 1 hour expiry

    // Store the reset token in the database
    user.resetToken = resetToken;
    user.resetTokenExpiry = resetTokenExpiry;
    await user.save();

    // Send password reset email
    const transporter = nodemailer.createTransport({
      service: 'Gmail',
      auth: {
        user: 'your_email@gmail.com',
        pass: 'your_email_password',
      },
    });

    const mailOptions = {
      from: 'your_email@gmail.com',
      to: email,
      subject: 'Password Reset',
      text: `Please use the following token to reset your password: ${resetToken}`,
    };

    await transporter.sendMail(mailOptions);

    res.json({ success: true, message: 'Password reset email sent' });
  } catch (error) {
    console.error('Error in /reset-password:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

// Password update route
app.post('/update-password', async (req, res) => {
  const { email, resetToken, newPassword } = req.body;

  // Validate new password format
  if (!validatePassword(newPassword)) {
    return res.status(400).json({ success: false, message: 'Password must be at least 8 characters long, start with a capital letter, and contain at least one number.' });
  }

  try {
    const user = await User.findOne({
      email,
      resetToken,
      resetTokenExpiry: { $gt: Date.now() }
    });
    if (!user) {
      return res.status(400).json({ success: false, message: 'Invalid or expired reset token' });
    }

    // Hash the new password
    const hashedPassword = await bcrypt.hash(newPassword, 10);

    // Update user password and clear resetToken
    user.password = hashedPassword;
    user.resetToken = undefined;
    user.resetTokenExpiry = undefined;
    await user.save();

    res.json({ success: true, message: 'Password updated successfully' });
  } catch (error) {
    console.error('Error in /update-password:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
