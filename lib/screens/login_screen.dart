import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON encoding/decoding
import 'package:flutter/services.dart' show rootBundle; // For loading assets
import 'home_screen.dart'; // อ้างอิงไปยังไฟล์ home_screen
import 'package:path_provider/path_provider.dart'; // For accessing file system
import 'dart:io'; // For reading files

class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Circular icon at the top
              CircleAvatar(
                radius: 60, // Adjust the size of the icon
                backgroundColor: Colors.cyan,
                child: ClipOval(
                  child: Image.asset(
                    'assets/image/user.png', // Path to the image
                    fit: BoxFit.cover,
                    width: 80, // Adjust the size of the image
                    height: 80,   
                  ),
                ),
              ),
              SizedBox(height: 40), // Add spacing between icon and fields
              
              // Username input
              TextField(
                controller: usernameController,
                style: TextStyle(color: Colors.white), // Text color
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Colors.cyan), // Label color
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange), // Border color
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyan), // Focused border color
                  ),
                ),
              ),
              SizedBox(height: 20), // Add spacing between text fields
              
              // Password input
              TextField(
                controller: passwordController,
                obscureText: true,
                style: TextStyle(color: Colors.white), // Text color
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.cyan), // Label color
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange), // Border color
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyan), // Focused border color
                  ),
                ),
              ),
              SizedBox(height: 30), // Add spacing before the login button
              
              // Login button with outlined style
              OutlinedButton(
                onPressed: () async {
                  bool isValid = await checkLogin(
                    usernameController.text,
                    passwordController.text,
                  );

                  if (isValid) {
                    // ถ้าล็อกอินสำเร็จ
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()), // ไปที่หน้า Home
                    );
                  } else {
                    // ถ้าชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง')),
                    );
                  }
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.cyan, width: 2), // Border color and width
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.cyan, fontSize: 18), // Button text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> checkLogin(String username, String password) async {
    try {
      // โหลดข้อมูลจาก user.json
      String data = await rootBundle.loadString('assets/user.json');
      List<dynamic> users = jsonDecode(data);

      // ตรวจสอบข้อมูลผู้ใช้
      for (var user in users) {
        if (user['username'] == username && user['password'] == password) {
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error loading user data: $e');
      return false;
    }
  }
}