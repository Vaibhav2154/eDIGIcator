import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:edigicator/services/language_provider.dart';

class KannadaHome extends ConsumerStatefulWidget {
  final int selectedClass; // Receive the selected class
  final String subject; // Receive subject name

  const KannadaHome({super.key, required this.selectedClass, required this.subject});

  @override
  _KannadaHomeState createState() => _KannadaHomeState();
}

class _KannadaHomeState extends ConsumerState<KannadaHome> {
  int _selectedIndex = 0; // Track selected tab index

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // If "Home" tab is selected, navigate back
    if (index == 0) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      Center(
        child: Text(
          getTranslatedText(
            ref, 
            'Class ${widget.selectedClass} ${widget.subject} Syllabus', 
            'ಶ್ರೇಣಿಯ ${widget.selectedClass} ${widget.subject} ಪಠ್ಯಕ್ರಮ'
          ),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      ResourcesPage(selectedClass: widget.selectedClass, subject: widget.subject), // Pass subject parameter
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          getTranslatedText(ref, '${widget.subject} Syllabus', '${widget.subject} ಪಠ್ಯಕ್ರಮ'),
        ),
      ),
      body: _pages[_selectedIndex], // Display the selected page
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

  // Helper function for language translation
  String getTranslatedText(WidgetRef ref, String enText, String knText) {
    final String currentLanguage = ref.watch(languageProvider);
    return currentLanguage == "kn" ? knText : enText;
  }
}

// Resources Page with class-based content
class ResourcesPage extends StatelessWidget {
  final int selectedClass;
  final String subject;

  const ResourcesPage({super.key, required this.selectedClass, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$subject Resources for Class $selectedClass',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
