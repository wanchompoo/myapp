import 'package:flutter/material.dart';

class LogisticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logistics Engineering'),
        backgroundColor: Color.fromARGB(255, 97, 25, 25),
      ),
      body: Center(
        child: Text(
          'Logistics Engineering Department',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
