import 'dart:convert';
import 'package:edigicator/services/translation_service.dart';
import 'package:edigicator/services/language_provide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:edigicator/pages/latestnewspage.dart';
import 'package:edigicator/pages/chat_page.dart'; // Import Chatbot Page
import 'package:edigicator/pages/compihome.dart' as compi;
import 'package:edigicator/pages/syllabushome.dart';// Import Compihome Page

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  

    @override
    ConsumerState<HomePage> createState() => _HomePageState();
  }
  
  class _HomePageState extends ConsumerState<HomePage> {
    int _selectedIndex = 1;
   Future<String> fetchQuote(WidgetRef ref) async {
    final String currentLanguage = ref.watch(languageProvider);
    final response = await http.get(Uri.parse('https://zenquotes.io/api/random'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final String quote = data[0]['q'];
      // Translate the quote to the current language
      return await TranslationService.translateText(quote, currentLanguage);
    } else {
      throw Exception('Failed to load quote');
    }
  }
    @override
   
    Widget build(BuildContext context) {
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LatestNewsPage()),
                  );
                },
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Competitive Exam Card (Tappable)
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  compi.Compihome(),), // Navigate to Compihome
                      );
                    },
                    child: _buildImageCard('assets/competitve.jpg', 'Competitive'),
                  ),
                ),
                const SizedBox(width: 12), // Space between images

                // Syllabus Card (Tappable)
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                       Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  Syllabushome()), // Navigate to SyllabusHome
                      );
                    },
                    child: _buildImageCard('assets/syllabus.jpg', 'Syllabus'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar with Chatbot in the Center
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _navigateToPage,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chatbot'),
          BottomNavigationBarItem(icon: Icon(Icons.question_answer), label: 'Q & A'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        ],
      ),
    );
  }

  Widget _buildImageCard(String imagePath, String title) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              imagePath,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 15,
          left: 15,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToPage(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
        break;
      case 1:
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) =>  ChatScreen()));
        break;
      case 3:
        // Navigator.push(context, MaterialPageRoute(builder: (context) => const QnaPage()));
        break;
      case 4:
        // Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage()));
        break;
    }
  }
}
