import 'package:flutter/material.dart';

class ActivityScreen extends StatelessWidget {
  final String activity;
 
  ActivityScreen({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(activity),
      ),
      body: Center(
        child: Text('Activity: $activity'),
      ),
    );
  }
}
