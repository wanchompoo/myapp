import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AmePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Agricultural Engineering',
          style: GoogleFonts.roboto(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 97, 25, 25),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Text(
          'Welcome to the Agricultural Engineering page!',
          style: GoogleFonts.roboto(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
