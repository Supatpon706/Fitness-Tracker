import 'dart:convert';

class ActivityData {
  final double time; // Total time in minutes
  final double distance; // Total distance in kilometers
  final int bpm; // Beats per minute (use `int` instead of `double` for BPM)
  final DateTime date; // Date of activity
  final String type; // Type of activity (running, swimming, cycling)

  ActivityData({
    required this.time,
    required this.distance,
    required this.bpm,
    required this.date,
    required this.type,
  });

  // Method to convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'distance': distance,
      'bpm': bpm,
      'date': date.toIso8601String(), // Convert DateTime to ISO 8601 string
      'type': type,
    };
  }

  // Factory method to create an object from JSON with error handling
  factory ActivityData.fromJson(Map<String, dynamic> json) {
    try {
      return ActivityData(
        time: json['time']?.toDouble() ?? 0.0, // Handle null and ensure double
        distance: json['distance']?.toDouble() ?? 0.0, // Handle null and ensure double
        bpm: json['bpm'] ?? 0, // Handle null and ensure int
        date: DateTime.parse(json['date']), // Parse ISO 8601 date string
        type: json['type'] ?? 'unknown', // Default to 'unknown' if null
      );
    } catch (e) {
      throw FormatException('Error parsing ActivityData: $e');
    }
  }

  @override
  String toString() {
    return 'ActivityData(time: $time, distance: $distance, bpm: $bpm, date: $date, type: $type)';
  }
}

void main() {
  // Example usage
  ActivityData activity = ActivityData(
    time: 45.0,
    distance: 10.5,
    bpm: 150,
    date: DateTime.now(),
    type: 'running',
  );

  // Convert to JSON string
  String jsonData = jsonEncode(activity.toJson());
  print('JSON data: $jsonData');

  // Convert JSON back to object
  Map<String, dynamic> decodedJson = jsonDecode(jsonData);
  ActivityData newActivity = ActivityData.fromJson(decodedJson);

  print('Decoded activity: ${newActivity.type}, ${newActivity.time} minutes');
}
