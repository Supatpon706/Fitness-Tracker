import 'package:flutter/material.dart';
import 'login_screen.dart'; // Reference to your login screen

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon or Image (Running shoe-like icon)
            CircleAvatar(
              radius: 60, // Adjust the size of the icon
              backgroundColor: Colors.cyan,
              child: ClipOval(
                child: Image.asset(
                  'assets/image/load.png', // Path to the image
                  fit: BoxFit.cover,
                  width: 80, // Adjust the size of the image
                  height: 80,
                ),
              ),
            ),
            SizedBox(height: 20),
            
            // Text for "Fitness Tracker"
            Text(
              'Fitness Tracker',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 30),

            // Button for "START NOW"
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()), // Navigate to login screen
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple, // Button color
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Adjust padding
              ),
              child: Text(
                'START NOW',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white, // Text color inside the button
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black, // Set the background to black like in the image
    );
  }
}
