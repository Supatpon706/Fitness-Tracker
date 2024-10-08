import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'activity_data.dart'; // Assuming ActivityData class is available
import 'running_screen.dart'; // Importing running, cycling, and swimming screens
import 'cycling_screen.dart';
import 'swimming_screen.dart';

class ProfileScreen extends StatefulWidget {
  final List<ActivityData> runningData;
  final List<ActivityData> cyclingData;
  final List<ActivityData> swimmingData;

  ProfileScreen({
    required this.runningData,
    required this.cyclingData,
    required this.swimmingData,
  });

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = '';

  // Function to load the username from the user.json file
  Future<void> _loadUserData() async {
    try {
      final String response = await rootBundle.loadString('assets/user.json');
      final data = json.decode(response);
      setState(() {
        username = data['username']; // Assuming the user.json contains {"username": "YourUsername"}
      });
    } catch (e) {
      print("Error loading user data: $e");
    }
  }

  // Function to calculate average BPM across running, cycling, and swimming
  double get averageBPM {
    List<ActivityData> allData = [
      ...widget.runningData,
      ...widget.cyclingData,
      ...widget.swimmingData
    ];

    if (allData.isEmpty) return 0;

    double totalBPM =
        allData.map((e) => e.bpm).reduce((a, b) => a + b).toDouble();
    return totalBPM / allData.length;
  }

  // Function to calculate average distance across running, cycling, and swimming
  double get averageDistance {
    List<ActivityData> allData = [
      ...widget.runningData,
      ...widget.cyclingData,
      ...widget.swimmingData
    ];

    if (allData.isEmpty) return 0;

    double totalDistance =
        allData.map((e) => e.distance).reduce((a, b) => a + b);
    return totalDistance / allData.length;
  }

  // Function to show a confirmation dialog before logging out
  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            ElevatedButton(
              child: Text('Logout'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Navigate to login screen after logout
                Navigator.pushReplacementNamed(context, '/login'); // Assuming '/login' is your login screen route
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load user data when the screen initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset('assets/image/back.png', width: 24, height: 24),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Image.asset('assets/image/turn-off.png', width: 24, height: 24),
            onPressed: () {
              _showLogoutConfirmationDialog(context); // Trigger logout confirmation
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Profile picture
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.cyan,
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/image/user.png', // Assuming user.png is your profile image
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Display username from user.json
            Text(
              username.isNotEmpty ? username : 'Loading...', // Show 'Loading...' until the username is loaded
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            // Average Distance Container
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.orange, width: 3),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(
                    'Average Distance (Km)',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    averageDistance.toStringAsFixed(2),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 60,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Average BPM Container
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.yellow, width: 3),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(
                    'Average Beats Per Minute (BPM)',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    averageBPM.toStringAsFixed(0),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 60,
                    ),
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
