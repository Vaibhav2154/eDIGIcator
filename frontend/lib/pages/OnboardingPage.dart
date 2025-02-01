import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:edigicator/pages/HomePage.dart'; // Ensure HomePage exists
import 'package:edigicator/services/language_provider.dart'; // Ensure this path is correct

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

  String _timeOfDayToString(TimeOfDay? time) {
    if (time == null) return ref.watch(languageProvider) == "en" ? 'Select Time' : 'ಸಮಯವನ್ನು ಆಯ್ಕೆಮಾಡಿ';
    final now = DateTime.now();
    return DateFormat.jm().format(DateTime(now.year, now.month, now.day, time.hour, time.minute));
  }

  void _saveSchedule() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  // Function to translate text dynamically
  String getTranslatedText(String enText, String knText) {
    final String currentLanguage = ref.watch(languageProvider);
    return currentLanguage == "kn" ? knText : enText;
  }

  @override
  Widget build(BuildContext context) {
    final String currentLanguage = ref.watch(languageProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(getTranslatedText('Set Your Daily Schedule', 'ನಿಮ್ಮ ದೈನಂದಿನ ವೇಳಾಪಟ್ಟಿಯನ್ನು ಹೊಂದಿಸಿ')),
            const SizedBox(height: 5),
            Text(
              getTranslatedText('Lets get to know you more', 'ನಿಮ್ಮ ಬಗ್ಗೆ ಹೆಚ್ಚು ತಿಳಿದುಕೊಳ್ಳೋಣ'),
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          DropdownButton<String>(
            icon: const Icon(Icons.language),
            value: currentLanguage == "en" ? "English" : "Kannada",
            onChanged: (String? newValue) {
              final newLanguageCode = newValue == "English" ? "en" : "kn";
              ref.read(languageProvider.notifier).state = newLanguageCode;
            },
            items: <String>['English', 'Kannada']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              ListTile(
                title: Text(getTranslatedText('Wake-up Time', 'ಎದ್ದ ಸಮಯ')),
                subtitle: Text(_timeOfDayToString(wakeUpTime)),
                trailing: const Icon(Icons.access_alarm),
                onTap: () => _selectTime(context, (time) => wakeUpTime = time),
              ),
              const Divider(),
              ListTile(
                title: Text(getTranslatedText('Bed Time', 'ಮಲಗುವ ಸಮಯ')),
                subtitle: Text(_timeOfDayToString(bedTime)),
                trailing: const Icon(Icons.bedtime),
                onTap: () => _selectTime(context, (time) => bedTime = time),
              ),
              const Divider(),
              ListTile(
                title: Text(getTranslatedText('Study Time', 'ಅಧ್ಯಯನ ಸಮಯ')),
                subtitle: Text(_timeOfDayToString(studyTime)),
                trailing: const Icon(Icons.school),
                onTap: () => _selectTime(context, (time) => studyTime = time),
              ),
              const Divider(),
              TextField(
                controller: schoolTimeController,
                decoration: InputDecoration(
                  labelText: getTranslatedText(
                    'School Timings (e.g. 9:00 AM - 3:00 PM)',
                    'ಶಾಲೆಯ ಸಮಯ (ಉದಾ. 9:00 AM - 3:00 PM)',
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.access_time),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: goalController,
                decoration: InputDecoration(
                  labelText: getTranslatedText(
                    'What is your life goal? (e.g. Scientist, Agriculturist)',
                    'ನಿಮ್ಮ ಜೀವನದ ಗುರಿ ಏನು? (ಉದಾ. ವಿಜ್ಞಾನಿ, ಕೃಷಿಕ)',
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.lightbulb_outline),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveSchedule,
                  child: Text(
                    getTranslatedText('Save Schedule', 'ವೇಳಾಪಟ್ಟಿಯನ್ನು ಉಳಿಸಿ'),
                    style: const TextStyle(fontSize: 18),
                  ),
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
    goalController.dispose();
    super.dispose();
  }
}