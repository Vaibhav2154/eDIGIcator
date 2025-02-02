import 'package:edigicator/services/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SocialHome extends ConsumerStatefulWidget {
  final int selectedClass; // Receive selected class
  final String subject; // Receive subject name

  const SocialHome({super.key, required this.selectedClass, required this.subject});

  @override
  _SocialHomeState createState() => _SocialHomeState();
}

class _SocialHomeState extends ConsumerState<SocialHome> {
  int _selectedIndex = 1; // Default to 'Resources' tab

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pop(context); // Navigate back when "Home" is tapped
    } else {
      setState(() {
        _selectedIndex = index; // Update the selected index
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      const Center(child: Text('Home Page')), // Placeholder for Home
      ResourcesPage(selectedClass: widget.selectedClass, subject: widget.subject), // Pass subject parameter
      const ThreeDResourcesPage(), // Dedicated 3D resources page
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
          BottomNavigationBarItem(
            icon: Icon(Icons.spatial_audio),
            label: '3D Resources',
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

// 3D Resources Page
class ThreeDResourcesPage extends StatelessWidget {
  const ThreeDResourcesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        '3D Social Studies Resources',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
