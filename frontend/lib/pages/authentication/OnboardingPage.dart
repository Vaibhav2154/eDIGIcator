import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:edigicator/pages/home/HomePage.dart';

class OnboardingPage extends ConsumerStatefulWidget {

  const OnboardingPage({super.key, required this.username});
  final dynamic username;

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  TimeOfDay? bedTime;
  TimeOfDay? studyTime;
  final TextEditingController schoolStartTime = TextEditingController();
  final TextEditingController schoolEndTime = TextEditingController();
  final TextEditingController studyGoal = TextEditingController();
  bool _isLoading = false;

  String _timeOfDayToString(TimeOfDay? time) {
    if (time == null) return '';
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, time.hour, time.minute).toIso8601String();
  }

  Future<void> _selectTime(BuildContext context, Function(TimeOfDay) onTimeSelected) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
      setState(() {
        onTimeSelected(selectedTime);
      });
    }
  }

  Future<void> _saveSchedule() async {
    setState(() => _isLoading = true);

    final String apiUrl = "http://10.0.2.2:8000/api/users/updateSchedule"; // Match backend

    final prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userId'); // Retrieve user ID

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: User ID not found")),
      );
      setState(() => _isLoading = false);
      return;
    }

    final Map<String, dynamic> requestData = {
      "userId": userId, // Send user ID
      "bedtime": bedTime != null ? _timeOfDayToString(bedTime) : null,
      "studytime": studyTime != null ? _timeOfDayToString(studyTime) : null,
      "schooltime": {
        "start": schoolStartTime.text.isNotEmpty ? schoolStartTime.text : null,
        "end": schoolEndTime.text.isNotEmpty ? schoolEndTime.text : null,
      },
      "studyGoal": studyGoal.text.trim().isNotEmpty ? studyGoal.text.trim() : null,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Schedule updated successfully!")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        throw Exception("Failed to update schedule. Server response: ${response.body}");
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${error.toString()}")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Daily Schedule")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ListTile(
              title: Text("Bed Time"),
              subtitle: Text(bedTime != null ? _timeOfDayToString(bedTime) : 'Select Time'),
              trailing: Icon(Icons.bedtime),
              onTap: () => _selectTime(context, (time) => setState(() => bedTime = time)),
            ),
            ListTile(
              title: Text("Study Time"),
              subtitle: Text(studyTime != null ? _timeOfDayToString(studyTime) : 'Select Time'),
              trailing: Icon(Icons.school),
              onTap: () => _selectTime(context, (time) => setState(() => studyTime = time)),
            ),
            TextField(
              controller: schoolStartTime,
              decoration: InputDecoration(
                labelText: "School Start Time (e.g. 9:00 AM)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: schoolEndTime,
              decoration: InputDecoration(
                labelText: "School End Time (e.g. 3:00 PM)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: studyGoal,
              decoration: InputDecoration(
                labelText: "Study Goal",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveSchedule,
              child: _isLoading ? CircularProgressIndicator() : Text("Save Schedule"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    schoolStartTime.dispose();
    schoolEndTime.dispose();
    studyGoal.dispose();
    super.dispose();
  }
}
