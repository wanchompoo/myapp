import 'package:flutter/material.dart';

class DiePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Innovation Design'),
        backgroundColor: Color.fromARGB(255, 97, 25, 25),
      ),
      body: Center(
        child: Text(
          'Innovation Design Department',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
