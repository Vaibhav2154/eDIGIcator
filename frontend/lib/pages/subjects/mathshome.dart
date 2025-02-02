import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:edigicator/services/language_provider.dart';
import 'package:edigicator/pages/modulespage.dart';
import 'package:edigicator/pages/resource_page.dart'; // Import ResourcesPage

class MathsHome extends ConsumerStatefulWidget {
  final int selectedClass;
  final String subject;

  const MathsHome({super.key, required this.selectedClass, required this.subject});

  @override
  _MathsHomeState createState() => _MathsHomeState();
}

class _MathsHomeState extends ConsumerState<MathsHome> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pop(context);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  // Create a Resources page widget
  Widget _buildResourcesPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Module List Button
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const YoutubeVideoPlayerFlutter(),
                ),
              );
            },
            icon: const Icon(Icons.list),
            label: Text(
              getTranslatedText(ref, 'View Modules', 'ಮಾಡ್ಯೂಲ್‌ಗಳನ್ನು ವೀಕ್ಷಿಸಿ'),
            ),
          ),
          const SizedBox(height: 20),
          // YouTube Player Button
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const YoutubeVideoPlayerFlutter(),
                ),
              );
            },
            icon: const Icon(Icons.play_circle_filled),
            label: Text(
              getTranslatedText(ref, 'Watch Video', 'ವೀಡಿಯೊ ನೋಡಿ'),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // YouTube-like color
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          // Navigate to Resources Page Button
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResourcesPage(
                    selectedClass: widget.selectedClass,
                    subject: widget.subject,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.book),
            label: Text(
              getTranslatedText(ref, 'View Textbook', 'ಪಾಠಪುಸ್ತಕವನ್ನು ವೀಕ್ಷಿಸಿ'),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      const Center(child: Text('Home')), // Placeholder for Home page
      _buildResourcesPage(), // Use the new resources page
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          getTranslatedText(
            ref,
            '${widget.subject} Syllabus',
            '${widget.subject} ಪಠ್ಯಕ್ರಮ',
          ),
        ),
      ),
      body: _pages[_selectedIndex],
      
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Resources',
          ),
        ],
      ),
    );
  }

  String getTranslatedText(WidgetRef ref, String enText, String knText) {
    final String currentLanguage = ref.watch(languageProvider);
    return currentLanguage == "kn" ? knText : enText;
  }
}
