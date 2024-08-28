import 'package:flutter/material.dart';
import 'package:myapp/register_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:
          'การพัฒนาแอปพลิเคชั่นทำเนียบรุ่นสำหรับนักศึกษาคณะวิศวกรรมศาสตร์และเทคโนโลยีอุตสาหกรรม',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 14),
          bodyLarge: TextStyle(fontSize: 14, color: Colors.white),
        ),
      ),
      home: Welcome(),
    );
  }
}

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                'https://scontent.fkkc1-1.fna.fbcdn.net/v/t39.30808-6/444765613_852977763535496_6274291394645160478_n.jpg?_nc_cat=107&ccb=1-7&_nc_sid=6ee11a&_nc_ohc=70MvXhWw0T8Q7kNvgG7Ev65&_nc_ht=scontent.fkkc1-1.fna&oh=00_AYDt4n9vJRlnYqVgt1v8wq3T47ZPq15-0H2MXrnNW9Q29A&oe=66D3BB73',
                width: 150,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.error, size: 150, color: Colors.red);
                },
              ),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Text(
              'ยินดีต้อนรับสู่ระบบ ทำเนียบรุ่นนักศึกษา',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: const Color.fromARGB(255, 75, 72, 72),
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 6),
          Center(
            child: Text(
              'การพัฒนาแอปพลิเคชั่นทำเนียบรุ่นสำหรับนักศึกษาคณะวิศวกรรมศาสตร์และเทคโนโลยีอุตสาหกรรม',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color.fromARGB(255, 75, 72, 72),
                  ),
            ),
          ),
          SizedBox(height: 3),
          Center(
            child: Text(
              'กรุณาลงชื่อเข้าใช้เพื่อเข้าถึงข้อมูลของคุณและฟังก์ชันอื่นๆที่มีในระบบนี้',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color.fromARGB(255, 210, 99, 62),
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 142, 169, 200),
              shadowColor: Colors.grey,
              elevation: 20,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'ลงชื่อเข้าใช้',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
