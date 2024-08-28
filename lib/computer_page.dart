import 'dart:typed_data'; // ใช้สำหรับ Web
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:html' as html; // ใช้สำหรับ Web
import 'package:http/http.dart' as http; // สำหรับทำการ HTTP Request
import 'dart:convert'; // สำหรับแปลงข้อมูล JSON

class ComputerPage extends StatefulWidget {
  @override
  _ComputerPageState createState() => _ComputerPageState();
}

class _ComputerPageState extends State<ComputerPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  Uint8List? _webImageData;
  String? _profileImageUrl;
  String? _userId = "dummy_user_id"; // รหัสผู้ใช้ที่ได้รับจากระบบของคุณ

  final double bottomBarHeight = 56.0;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    if (_userId != null) {
      final response = await http.get(
        Uri.parse('https://your-api-url.com/profile_images/$_userId.jpg'),
      );
      if (response.statusCode == 200) {
        setState(() {
          _profileImageUrl = json.decode(response.body)['url'];
        });
      } else {
        print('Error loading image');
      }
    }
  }

  Future<void> _pickImage() async {
    final uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.onChange.listen((e) async {
      final files = uploadInput.files;
      if (files!.isEmpty) return;
      final reader = html.FileReader();
      reader.readAsArrayBuffer(files[0]!);
      reader.onLoadEnd.listen((e) async {
        final bytes = reader.result as Uint8List?;
        if (bytes != null) {
          setState(() {
            _webImageData = bytes;
          });
          await _uploadImage();
        }
      });
    });
    uploadInput.click();
  }

  Future<void> _uploadImage() async {
    if (_userId != null) {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://your-api-url.com/upload_profile_image'),
      );
      request.fields['userId'] = _userId!;
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        _webImageData!,
        filename: 'profile_image.jpg',
      ));

      try {
        final response = await request.send();
        if (response.statusCode == 200) {
          final responseBody = await response.stream.bytesToString();
          setState(() {
            _profileImageUrl = json.decode(responseBody)['url'];
          });
        }
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  Future<void> _deleteImage() async {
    if (_userId != null) {
      final response = await http.delete(
        Uri.parse('https://your-api-url.com/delete_profile_image/$_userId'),
      );
      if (response.statusCode == 200) {
        setState(() {
          _profileImageUrl = null; // Clear the image URL after deletion
          _webImageData = null; // Clear the web image data after deletion
        });
      } else {
        print('Error deleting image');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = "user@example.com"; // คุณต้องใช้วิธีของคุณเองในการดึงอีเมลของผู้ใช้
    final username = email.split('@').first;
    final filteredUsername = username.replaceAll(RegExp(r'\d'), '');

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          title: Row(
            children: [
              Icon(Icons.person_4,
                  color: const Color.fromARGB(255, 67, 147, 232)),
              SizedBox(width: 8),
              Text(
                'HELLO! $filteredUsername',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          automaticallyImplyLeading: false,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'สาขาวิชาวิศวกรรมคอมพิวเตอร์',
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  color: const Color.fromARGB(255, 49, 45, 45),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 3),
            Center(
              child: Text(
                'กรุณาระบุข้อมูลให้ครบถ้วน',
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: _webImageData != null
                        ? MemoryImage(_webImageData!) as ImageProvider
                        : _profileImageUrl != null
                            ? NetworkImage(_profileImageUrl!) as ImageProvider
                            : null,
                    child: _webImageData == null && _profileImageUrl == null
                        ? Icon(
                            Icons.person,
                            size: 70,
                            color: Colors.grey[700],
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(
                            255, 218, 214, 214), // ไม่มีการตั้งค่าเงา
                        shape: BoxShape.circle,
                      ),
                      width: 30,
                      height: 50,
                      child: PopupMenuButton<String>(
                        icon: Icon(
                          Icons.camera_alt,
                          color: const Color.fromARGB(255, 0, 0, 0),
                          size: 20,
                        ),
                        iconSize: 15,
                        padding: EdgeInsets.all(4.0),
                        tooltip: '',
                        itemBuilder: (BuildContext context) {
                          return [
                            PopupMenuItem<String>(
                              value: 'change',
                              child: Text('เลือกรูปโปรไฟล์'),
                            ),
                            if (_profileImageUrl != null)
                              PopupMenuItem<String>(
                                value: 'delete',
                                child: Text('ลบรูปโปรไฟล์'),
                              ),
                          ];
                        },
                        onSelected: (String value) {
                          if (value == 'change') {
                            _pickImage();
                          } else if (value == 'delete') {
                            _deleteImage();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'ข้อมูลข้องคุณ',
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        // Handle form submission
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Processing Data')),
                        );
                      }
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
