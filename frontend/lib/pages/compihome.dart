import 'package:flutter/material.dart';
import 'package:edigicator/pages/jeehome.dart';
import 'package:edigicator/pages/kcethome.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:edigicator/services/language_provider.dart'; // Import the language provider

class Compihome extends ConsumerWidget {
  const Compihome({super.key});

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
                'Welcome to the Competitive Exams Section!',
                'ಪ್ರತಿಯೊಂದು ಪರೀಕ್ಷೆಗಳ ವಿಭಾಗಕ್ಕೆ ಸ್ವಾಗತ!',
              ),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Centering the column of images
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // KCET Image with Text
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const KceHome()),
                    );
                  },
                  child: Column(
                    children: [
                      Image.asset('assets/competitve.jpg', height: 120), // KCET Image
                      const SizedBox(height: 8),
                      Text(
                        getTranslatedText(ref, 'KCET', 'ಕೆಸಿಇಟಿ'), // Translated text
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20), // Space between images
                // JEE Image with Text
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const JeeHome()),
                    );
                  },
                  child: Column(
                    children: [
                      Image.asset('assets/syllabus.jpg', height: 120), // JEE Image
                      const SizedBox(height: 8),
                      Text(
                        getTranslatedText(ref, 'JEE', 'ಜೇಈಇ'), // Translated text
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
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