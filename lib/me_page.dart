import 'package:flutter/material.dart';

class MechanicalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mechanical Engineering'),
        backgroundColor: Color.fromARGB(255, 97, 25, 25),
      ),
      body: Center(
        child: Text(
          'Mechanical Engineering Department',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
