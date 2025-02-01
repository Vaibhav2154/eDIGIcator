import 'package:edigicator/services/language_provider.dart';
import 'package:flutter/material.dart';
// Import the HomePage widget
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MathsHome extends ConsumerStatefulWidget {
  const MathsHome({super.key});

  @override
  _MathsHomeState createState() => _MathsHomeState();
}

class _MathsHomeState extends ConsumerState<MathsHome> {
  int _selectedIndex = 0; // To keep track of the selected tab

  // List of pages corresponding to the tabs
  final List<Widget> _pages = [
    const Center(child: Text('Resources')), // Placeholder for Resources page
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update selected tab index
    });

    // If the 'Home' tab is tapped, navigate back to the HomePage
    if (index == 0) {
      Navigator.pop(context); // This will pop the current page and navigate back
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          getTranslatedText(ref, 'Maths Syllabus', 'ಗಣಿತ ಸಿಲಬಸ್'),
        ),
      ),
      body: _pages[_selectedIndex], // Render the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Highlight the selected tab
        onTap: _onItemTapped, // Handle tab change
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // Icon for Home
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books), // Icon for Resources
            label: 'Resources',
          ),
        ],
      ),
    );
  }

  // Helper function to get translated text based on the current language
  String getTranslatedText(WidgetRef ref, String enText, String knText) {
    final String currentLanguage = ref.watch(languageProvider);
    return currentLanguage == "kn" ? knText : enText;
  }
}