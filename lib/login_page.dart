import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/register_page.dart';
import 'package:myapp/user_detail_page.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _resetEmailController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
    _emailController.addListener(_updateTextColor);
    _passwordController.addListener(_updateTextColor);
  }

  @override
  void dispose() {
    _emailController.removeListener(_updateTextColor);
    _passwordController.removeListener(_updateTextColor);
    super.dispose();
  }

  void _updateTextColor() {
    setState(() {});
  }

  void _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _emailController.text = prefs.getString('email') ?? '';
      _passwordController.text = prefs.getString('password') ?? '';
      _rememberMe = prefs.getBool('rememberMe') ?? false;
    });
  }

  void _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString('email', _emailController.text.trim());
      await prefs.setString('password', _passwordController.text.trim());
    } else {
      await prefs.remove('email');
      await prefs.remove('password');
    }
    await prefs.setBool('rememberMe', _rememberMe);
  }

  void _showSnackbar(String message, {Icon? icon, Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: <Widget>[
            if (icon != null) icon,
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        duration: Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        backgroundColor: backgroundColor ?? Colors.red,
        action: SnackBarAction(
          label: 'Close',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  Future<void> _login(BuildContext context) async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      _showSnackbar('Please enter email and password.');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(
            'http://localhost:3000/login'), // Change this to your API endpoint
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': _emailController.text.trim(),
          'password': _passwordController.text.trim(),
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final name = data['name'] ?? '';

          _saveCredentials();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DetailPage(name: name)),
          );
        } else {
          _showSnackbar(
              'Invalid credentials. Please register if you do not have an account.');
        }
      } else {
        _showSnackbar('Login failed: ${response.body}');
      }
    } catch (e) {
      _showSnackbar('Login failed: ${e.toString()}');
    }
  }

  Future<void> _resetPassword(BuildContext context) async {
    if (_resetEmailController.text.trim().isEmpty) {
      _showSnackbar('Please enter your email address.');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(
            'http://localhost:3000/reset-password'), // Change this to your API endpoint
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': _resetEmailController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        _showSnackbar(
          'Please check your email for instructions to reset your password.',
          icon: Icon(Icons.check_circle, color: Colors.green),
          backgroundColor: Colors.blue,
        );
      } else {
        Navigator.of(context).pop();
        _showSnackbar('Failed to send reset email. Please try again.');
      }
    } catch (e) {
      Navigator.of(context).pop();
      _showSnackbar('Failed to send reset email. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Text(
                  'LOGIN',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 28),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 7),
              Align(
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        text: 'Register',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 87, 153, 230),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterPage()),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              Container(
                width: 350,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(fontSize: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: Icon(Icons.email, color: Colors.blueGrey),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        color: _emailController.text.isEmpty
                            ? Colors.grey[600]
                            : Colors.black87,
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(fontSize: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: Icon(Icons.key, color: Colors.blueGrey),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.blueGrey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                      style: TextStyle(
                        color: _passwordController.text.isEmpty
                            ? Colors.grey[600]
                            : Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (bool? value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                            ),
                            Text(
                              'Remember Me',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text(
                                  'Reset Password',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        'Please enter your email to receive a password reset link.',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 16),
                                      TextField(
                                        controller: _resetEmailController,
                                        decoration: InputDecoration(
                                          labelText: 'Email',
                                          labelStyle: TextStyle(fontSize: 12),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          prefixIcon: Icon(Icons.email,
                                              color: Colors.blueGrey),
                                          filled: true,
                                          fillColor: Colors.white,
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                        ),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        style: TextStyle(
                                          color:
                                              _resetEmailController.text.isEmpty
                                                  ? Colors.grey[600]
                                                  : Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: () {
                                          _resetPassword(context);
                                        },
                                        child: Text('Send Reset Link'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 87, 153, 230),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        onPressed: () => _login(context),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              const Color.fromARGB(255, 87, 153, 230),
                          minimumSize: Size(350, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
