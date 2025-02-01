import 'package:flutter/material.dart';
import 'package:edigicator/pages/HomePage.dart'; // Assuming HomePage is in a separate file
import 'package:intl/intl.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  TimeOfDay? wakeUpTime;
  TimeOfDay? bedTime;
  TimeOfDay? studyTime;
  final TextEditingController schoolTimeController = TextEditingController();
  final TextEditingController goalController = TextEditingController();

  // Function to select time using TimePicker
  Future<void> _selectTime(BuildContext context, String type) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
      setState(() {
        if (type == 'wakeUp') {
          wakeUpTime = selectedTime;
        } else if (type == 'bedTime') {
          bedTime = selectedTime;
        } else if (type == 'studyTime') {
          studyTime = selectedTime;
        }
      });
    }
  }

  // Convert TimeOfDay to a formatted string (e.g., "9:00 AM")
  String _timeOfDayToString(TimeOfDay? time) {
    if (time == null) return ''; // Return empty if no time is selected
    final now = DateTime.now();
    final formattedTime = DateFormat.jm()
        .format(DateTime(now.year, now.month, now.day, time.hour, time.minute));
    return formattedTime;
  }

  // Function to navigate to the HomePage
  Future<void> _saveSchedule() async {
    // Simulate a successful action
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Set Your Daily Schedule'),
            const SizedBox(height: 5),
            const Text(
              'Let\'s get to know you more',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Wake Up Time Picker
              ListTile(
                title: const Text('Wake-up Time'),
                subtitle: Text(wakeUpTime?.format(context) ?? 'Select Time'),
                trailing: const Icon(Icons.access_alarm),
                onTap: () => _selectTime(context, 'wakeUp'),
              ),
              const Divider(),

              // Bed Time Picker
              ListTile(
                title: const Text('Bed Time'),
                subtitle: Text(bedTime?.format(context) ?? 'Select Time'),
                trailing: const Icon(Icons.bedtime),
                onTap: () => _selectTime(context, 'bedTime'),
              ),
              const Divider(),

              // Study Time Picker
              ListTile(
                title: const Text('Study Time'),
                subtitle: Text(studyTime?.format(context) ?? 'Select Time'),
                trailing: const Icon(Icons.school),
                onTap: () => _selectTime(context, 'studyTime'),
              ),
              const Divider(),

              // School Time Input
              TextField(
                controller: schoolTimeController,
                decoration: InputDecoration(
                  labelText: 'School Timings (e.g. 9:00 AM - 3:00 PM)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.access_time),
                ),
              ),
              const SizedBox(height: 20),

              // Life Goal Input
              TextField(
                controller: goalController,
                decoration: InputDecoration(
                  labelText: 'What is your life goal? (e.g. Scientist, Agriculturist)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.lightbulb_outline),
                ),
              ),
              const SizedBox(height: 30),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveSchedule, // Call the function to save data
                  child: const Text('Save Schedule', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    schoolTimeController.dispose();
    goalController.dispose(); // Dispose the goal controller
    super.dispose();
  }
}
