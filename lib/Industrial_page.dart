import 'package:flutter/material.dart';

class IndustrialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Industrial Engineering'),
        backgroundColor: Color.fromARGB(255, 97, 25, 25),
      ),
      body: Center(
        child: Text(
          'Industrial Engineering Page',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
