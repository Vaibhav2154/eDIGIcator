import 'dart:convert';
import 'package:edigicator/services/language_provide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/translation_service.dart';
import 'package:http/http.dart' as http;


class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  Future<String> fetchQuote(WidgetRef ref) async {
    final String currentLanguage = ref.watch(languageProvider);
    final response = await http.get(Uri.parse('https://zenquotes.io/api/random'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final String quote = data[0]['q'];
      // Translate the quote to the current language
      return TranslationService.translateText(quote, currentLanguage);
    } else {
      throw Exception('Failed to load quote');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String currentLanguage = ref.watch(languageProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text(
                'Edigicator',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: Image.asset(
                'assets/edigicatorlogo.png',
                height: 50,
              ),
            ),
            const Spacer(flex: 2),
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
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder<String>(
              future: fetchQuote(ref),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return Text(
                    snapshot.data!,
                    style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  );
                } else {
                  return const Center(child: Text('No quote available'));
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: const Text(
                  'Latest News',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Tap here to view the latest news.'),
                onTap: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}