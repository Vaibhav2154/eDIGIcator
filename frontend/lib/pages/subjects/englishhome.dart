import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:edigicator/services/language_provider.dart'; // Import the language provider

class EnglishHome extends ConsumerWidget {
  const EnglishHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the current language from the provider
    final String currentLanguage = ref.watch(languageProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          getTranslatedText(ref, 'English Syllabus', 'ಇಂಗ್ಲಿಷ್ ಸಿಲಬಸ್'),
        ),
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
                'Welcome to the English Syllabus Section!',
                'ಇಂಗ್ಲಿಷ್ ಸಿಲಬಸ್ ವಿಭಾಗಕ್ಕೆ ಸ್ವಾಗತ!',
              ),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Add more content here if needed
            Expanded(
              child: Center(
                child: Text(
                  getTranslatedText(
                    ref,
                    'This section contains the syllabus for English.',
                    'ಈ ವಿಭಾಗದಲ್ಲಿ ಇಂಗ್ಲಿಷ್ ಸಿಲಬಸ್ ಇರುತ್ತದೆ.',
                  ),
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
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