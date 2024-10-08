import 'package:flutter/material.dart';
import 'activity_data.dart';
import 'running_screen.dart';
import 'swimming_screen.dart';
import 'cycling_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ActivityData> runningData = [];
  List<ActivityData> swimmingData = [];
  List<ActivityData> cyclingData = [];

  void _showAddDataDialog(BuildContext context, String activityType) {
    final TextEditingController timeController = TextEditingController();
    final TextEditingController kilometerController = TextEditingController();
    final TextEditingController bpmController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Activity Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: timeController,
                decoration: InputDecoration(labelText: 'Total Time (minutes)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: kilometerController,
                decoration: InputDecoration(labelText: 'Total Kilometer'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: bpmController,
                decoration: InputDecoration(labelText: 'Total BPM'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Add'),
              onPressed: () {
                // Create new activity data
                ActivityData newActivity = ActivityData(
                  time: double.parse(timeController.text),
                  distance: double.parse(kilometerController.text),
                  bpm: int.parse(bpmController.text),  // Parsing as int for BPM
                  date: DateTime.now(),
                  type: activityType,
                );

                // Add data to the appropriate list based on the activity type
                setState(() {
                  if (activityType == 'RUNNING') {
                    runningData.add(newActivity);
                  } else if (activityType == 'SWIMMING') {
                    swimmingData.add(newActivity);
                  } else if (activityType == 'CYCLING') {
                    cyclingData.add(newActivity);
                  }
                });

                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 252, 252),
        title: Text('Dashboard'),
        leading: IconButton(
          icon: Image.asset(
            'assets/image/back.png',  // back.png image used for back button
            width: 24,
            height: 24,
          ),
          onPressed: () {
            Navigator.pop(context);  // Functionality to go back
          },
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    runningData: runningData,
                    swimmingData: swimmingData,
                    cyclingData: cyclingData,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/image/user.png'), // Profile image
                radius: 20, // Adjust the size of the profile image
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Profile icon at the top
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.cyan,
              child: ClipOval(
                child: Image.asset(
                  'assets/image/user.png',
                  fit: BoxFit.cover,
                  width: 80,
                  height: 80,
                ),
              ),
            ),
            SizedBox(height: 40),
            ActivityRow(
              text: 'RUNNING',
              activityType: 'RUNNING',
              onActivityTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RunningScreen(data: runningData)),
                );
              },
              onAddTap: () => _showAddDataDialog(context, 'RUNNING'),
            ),
            const SizedBox(height: 20),
            ActivityRow(
              text: 'SWIMMING',
              activityType: 'SWIMMING',
              onActivityTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SwimmingScreen(data: swimmingData)),
                );
              },
              onAddTap: () => _showAddDataDialog(context, 'SWIMMING'),
            ),
            const SizedBox(height: 20),
            ActivityRow(
              text: 'CYCLING',
              activityType: 'CYCLING',
              onActivityTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CyclingScreen(data: cyclingData)),
                );
              },
              onAddTap: () => _showAddDataDialog(context, 'CYCLING'),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom widget for activity rows
class ActivityRow extends StatelessWidget {
  final String text;
  final String activityType;
  final VoidCallback onActivityTap;
  final VoidCallback onAddTap;

  const ActivityRow({
    required this.text,
    required this.activityType,
    required this.onActivityTap,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onActivityTap,
            child: Text(text),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              padding: EdgeInsets.symmetric(vertical: 20),
              textStyle: TextStyle(fontSize: 20),
            ),
          ),
        ),
        SizedBox(width: 10),
        FloatingActionButton(
          onPressed: onAddTap,
          backgroundColor: Colors.blue,
          child: ImageIcon(
            AssetImage('assets/image/add.png'), // Use the icon image you want
            size: 30, // Adjust the size of the icon
          ),
        ),
      ],
    );
  }
}
