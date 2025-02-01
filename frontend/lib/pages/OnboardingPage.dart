import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:edigicator/pages/HomePage.dart';
import 'package:edigicator/services/language_provider.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  TimeOfDay? wakeUpTime;
  TimeOfDay? bedTime;
  TimeOfDay? studyTime;
  final TextEditingController schoolTimeController = TextEditingController();
  final TextEditingController goalController = TextEditingController();
  bool _isLoading = false;

  String _timeOfDayToString(TimeOfDay? time) {
    if (time == null) return 'Select Time';
    final now = DateTime.now();
    return DateFormat('HH:mm').format(DateTime(now.year, now.month, now.day, time.hour, time.minute));
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

    final String apiUrl = "http://10.0.2.2:8000/updateUserSchedule"; // Adjust port if needed

    final Map<String, dynamic> requestData = {
      "wakeUpTime": wakeUpTime != null ? _timeOfDayToString(wakeUpTime) : null,
      "bedTime": bedTime != null ? _timeOfDayToString(bedTime) : null,
      "studyTime": studyTime != null ? _timeOfDayToString(studyTime) : null,
      "schoolTime": schoolTimeController.text.isNotEmpty
          ? schoolTimeController.text
          : null,
      "studyGoal": goalController.text.trim().isNotEmpty ? goalController.text.trim() : null,
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
      appBar: AppBar(
        title: Text("Daily Schedule"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ListTile(
              title: Text("Wake-up Time"),
              subtitle: Text(_timeOfDayToString(wakeUpTime)),
              trailing: Icon(Icons.access_alarm),
              onTap: () => _selectTime(context, (time) => setState(() => wakeUpTime = time)),
            ),
            ListTile(
              title: Text("Bed Time"),
              subtitle: Text(_timeOfDayToString(bedTime)),
              trailing: Icon(Icons.bedtime),
              onTap: () => _selectTime(context, (time) => setState(() => bedTime = time)),
            ),
            ListTile(
              title: Text("Study Time"),
              subtitle: Text(_timeOfDayToString(studyTime)),
              trailing: Icon(Icons.school),
              onTap: () => _selectTime(context, (time) => setState(() => studyTime = time)),
            ),
            TextField(
              controller: schoolTimeController,
              decoration: InputDecoration(
                labelText: "School Timings (e.g. 9:00 AM - 3:00 PM)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: goalController,
              decoration: InputDecoration(
                labelText: "What is your life goal?",
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
    schoolTimeController.dispose();
    goalController.dispose();
    super.dispose();
  }
}
