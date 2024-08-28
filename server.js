const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const User = require('./models/User'); // นำเข้า User Model
const app = express();
const port = 3000;

app.use(bodyParser.json());

// เชื่อมต่อกับ MongoDB
mongoose.connect('mongodb://localhost:27017/alumni', {
  useNewUrlParser: true,
  useUnifiedTopology: true
});

// เส้นทางสำหรับการลงทะเบียนผู้ใช้ใหม่
app.post('/register', async (req, res) => {
  try {
    const { name, email, password } = req.body;

    // สร้างผู้ใช้ใหม่
    const newUser = new User({ name, email, password });
    const savedUser = await newUser.save();

    // ส่งข้อมูลตอบกลับ
    res.json({
      success: true,
      message: 'User registered successfully',
      data: savedUser
    });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({
      success: false,
      message: 'Error registering user',
      error: error.message
    });
  }
});

// เส้นทางสำหรับการล็อกอิน
app.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    // ตรวจสอบผู้ใช้จากอีเมล
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({
        success: false,
        message: 'User not found'
      });
    }

    // ตรวจสอบรหัสผ่าน
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({
        success: false,
        message: 'Invalid credentials'
      });
    }

    res.json({
      success: true,
      message: 'Logged in successfully',
      data: user
    });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({
      success: false,
      message: 'Error logging in',
      error: error.message
    });
  }
});

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
