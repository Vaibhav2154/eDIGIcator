import 'package:flutter/material.dart';
import 'package:edigicator/pages/HomePage.dart'; // Import the HomePage widget

class KannadaHome extends StatefulWidget {
  const KannadaHome({super.key});

  @override
  _KannadaHomeState createState() => _KannadaHomeState();
}

class _KannadaHomeState extends State<KannadaHome> {
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
        title: const Text('Kannada Syllabus'),
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
}
