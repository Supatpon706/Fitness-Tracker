import 'package:flutter/material.dart';
import 'activity_data.dart';

class RunningScreen extends StatefulWidget {
  final List<ActivityData> data;

  RunningScreen({required this.data});

  @override
  _RunningScreenState createState() => _RunningScreenState();
}

class _RunningScreenState extends State<RunningScreen> {
  double get averageTime => widget.data.isEmpty
      ? 0
      : widget.data.map((e) => e.time).reduce((a, b) => a + b) /
          widget.data.length;

  double get averageDistance => widget.data.isEmpty
      ? 0
      : widget.data.map((e) => e.distance).reduce((a, b) => a + b) /
          widget.data.length;

  double get averageBPM => widget.data.isEmpty
      ? 0
      : widget.data.map((e) => e.bpm).reduce((a, b) => a + b) /
          widget.data.length;

  // Function to delete an activity from the list
  void _deleteActivity(int index) {
    setState(() {
      widget.data.removeAt(index);
    });
  }

  // Function to show the edit dialog and update the activity
  void _showEditDialog(int index) {
    TextEditingController distanceController =
        TextEditingController(text: widget.data[index].distance.toString());
    TextEditingController bpmController =
        TextEditingController(text: widget.data[index].bpm.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Activity'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: distanceController,
                decoration: InputDecoration(labelText: 'Distance (km)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: bpmController,
                decoration: InputDecoration(labelText: 'BPM'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  widget.data[index] = ActivityData(
                    time: widget.data[index].time,
                    distance: double.parse(
                        distanceController.text), // Update distance
                    bpm: int.parse(bpmController.text), // Update bpm
                    date: widget.data[index].date,
                    type: 'running', // Correct type for RunningScreen
                  );
                });
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Function to show a confirmation dialog before deleting the activity
  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this activity?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteActivity(index); // Call delete function
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
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
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: Text('RUNNING',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Image.asset(
            'assets/image/back.png',
            width: 24,
            height: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Wrapping the run.png image in a yellow circular container
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 217, 49), // Yellow background color
                shape: BoxShape.circle, // Circular shape
              ),
              padding: EdgeInsets.all(16), // Padding around the image
              child: Image.asset(
                'assets/image/run.png',  // Ensure the image path is correct
                width: 100,
                height: 100,
              ),
            ),
            SizedBox(height: 10),
            Text('Today you run for...',
                style: TextStyle(color: Colors.white, fontSize: 18)),
            SizedBox(height: 20),
            // This section's background is set to yellow with an orange border
            Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 221, 201, 23), // Set background color to yellow
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange, width: 4), // Set border color to orange
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    '${averageDistance.toStringAsFixed(2)} km',
                    style: TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontSize: 32,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${averageBPM.toStringAsFixed(0)} BPM',
                    style: TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontSize: 32,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // The section below remains unchanged (with the original design)
            Expanded(
              child: ListView.builder(
                itemCount: widget.data.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.blue, // Set background color to blue
                      border: Border.all(color: Colors.white, width: 2), // White border
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Image.asset(
                        'assets/image/run.png', // Use the run.png image
                        width: 40,
                        height: 40,
                      ),
                      title: Text(
                        '${widget.data[index].distance} km at ${widget.data[index].bpm} BPM',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text('${widget.data[index].date}',
                          style: TextStyle(color: Colors.white)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255,
                                  255), // Circular white background
                              shape: BoxShape.circle,
                            ),
                            padding:
                                EdgeInsets.all(8.0), // Spacing around the icon
                            child: IconButton(
                              icon: ImageIcon(
                                AssetImage(
                                    'assets/image/edit.png'), // Use edit image here
                                size: 24,
                                color:
                                    Colors.black, // Change icon color if needed
                              ),
                              onPressed: () {
                                _showEditDialog(index); // Trigger edit dialog
                              },
                            ),
                          ),
                          SizedBox(width: 8), // Add spacing between the buttons
                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255,
                                  255), // Circular white background
                              shape: BoxShape.circle,
                            ),
                            padding:
                                EdgeInsets.all(8.0), // Spacing around the icon
                            child: IconButton(
                              icon: ImageIcon(
                                AssetImage(
                                    'assets/image/delete.png'), // Use delete image here
                                size: 24,
                                color:
                                    Colors.black, // Change icon color if needed
                              ),
                              onPressed: () {
                                _showDeleteConfirmationDialog(
                                    index); // Trigger delete dialog
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
