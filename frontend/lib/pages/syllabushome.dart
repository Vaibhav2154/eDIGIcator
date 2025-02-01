import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:edigicator/pages/subjects/englishhome.dart';
import 'package:edigicator/pages/subjects/kannadahome.dart';
import 'package:edigicator/pages/subjects/socialhome.dart';
import 'package:edigicator/pages/subjects/sciencehome.dart';
import 'package:edigicator/pages/subjects/mathshome.dart';
import 'package:edigicator/services/language_provider.dart'; // Import the language provider

class Syllabushome extends ConsumerWidget {
  const Syllabushome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the current language from the provider
    final String currentLanguage = ref.watch(languageProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:true, // To remove the back button
        title: const Text(
          'Hello student', // Title of the AppBar
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          // Language Switcher Dropdown
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: DropdownButton<String>(
              icon: const Icon(Icons.language),
              value: currentLanguage == "en" ? "English" : "Kannada",
              onChanged: (String? newValue) {
                final newLanguageCode = newValue == "English" ? "en" : "kn";
                ref.read(languageProvider.notifier).state = newLanguageCode; // Update language
              },
              items: <String>['English', 'Kannada']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Welcome Text (Translated)
            Text(
              getTranslatedText(
                ref,
                'Welcome to the Syllabus Exams Section!',
                'ಸ್ವಾಗತ! ಸಿಲಬಸ್ ಪರೀಕ್ಷೆಗಳ ವಿಭಾಗಕ್ಕೆ',
              ),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // GridView to display the subjects with icons
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // Two columns
                crossAxisSpacing: 16.0, // Space between columns
                mainAxisSpacing: 16.0, // Space between rows
                childAspectRatio: 1.0, // Make each card square
                children: [
                  // English
                  SubjectCard(
                    title: getTranslatedText(ref, 'English', 'ಇಂಗ್ಲಿಷ್'),
                    icon: Icons.language,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EnglishHome()),
                      );
                    },
                  ),
                  // Kannada
                  SubjectCard(
                    title: getTranslatedText(ref, 'Kannada', 'ಕನ್ನಡ'),
                    icon: Icons.language_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const KannadaHome()),
                      );
                    },
                  ),
                  // Social
                  SubjectCard(
                    title: getTranslatedText(ref, 'Social', 'ಸಮಾಜಶಾಸ್ತ್ರ'),
                    icon: Icons.school,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SocialHome()),
                      );
                    },
                  ),
                  // Science
                  SubjectCard(
                    title: getTranslatedText(ref, 'Science', 'ವಿಜ್ಞಾನ'),
                    icon: Icons.science,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ScienceHome()),
                      );
                    },
                  ),
                  // Maths
                  SubjectCard(
                    title: getTranslatedText(ref, 'Maths', 'ಗಣಿತ'),
                    icon: Icons.calculate,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MathsHome()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to get translated text based on the current language
  String getTranslatedText(WidgetRef ref, String enText, String knText) {
    final String currentLanguage = ref.watch(languageProvider);
    return currentLanguage == "kn" ? knText : enText;
  }
}

// Custom Widget for subject cards
class SubjectCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const SubjectCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.blueAccent, // Background color of the card
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 50.0,
                color: Colors.white,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}