import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileHelper {
  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get localFile async {
    final path = await localPath;
    return File('$path/datafig.json');
  }

  Future<Map<String, dynamic>> readData() async {
    try {
      final file = await localFile;
      if (!(await file.exists())) {
        await writeData({"activities": {"running": [], "swimming": [], "cycling": []}});
      }
      String contents = await file.readAsString();
      return jsonDecode(contents);
    } catch (e) {
      return {};
    }
  }

  Future<File> writeData(Map<String, dynamic> data) async {
    final file = await localFile;
    return file.writeAsString(jsonEncode(data));
  }

  Future<void> addActivity(String type, Map<String, dynamic> activity) async {
    Map<String, dynamic> data = await readData();
    if (data['activities'][type] != null) {
      data['activities'][type].add(activity);
      await writeData(data);
    }
  }

  Future<void> updateActivity(String type, int index, Map<String, dynamic> updatedActivity) async {
    Map<String, dynamic> data = await readData();
    if (data['activities'][type] != null && index < data['activities'][type].length) {
      data['activities'][type][index] = updatedActivity;
      await writeData(data);
    }
  }

  Future<void> deleteActivity(String type, int index) async {
    Map<String, dynamic> data = await readData();
    if (data['activities'][type] != null && index < data['activities'][type].length) {
      data['activities'][type].removeAt(index);
      await writeData(data);
    }
  }
}
