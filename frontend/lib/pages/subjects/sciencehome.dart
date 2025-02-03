import 'package:edigicator/services/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class ScienceHome extends ConsumerStatefulWidget {
  final int selectedClass; // Receive selected class
  final String subject; // Receive subject name

  const ScienceHome({super.key, required this.selectedClass, required this.subject});

  @override
  _ScienceHomeState createState() => _ScienceHomeState();
}

class _ScienceHomeState extends ConsumerState<ScienceHome> {
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
      const ThreeDResourcesPage(), // 3D resources page
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
    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: Text(
              '$subject Resources for Class $selectedClass',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          _imageResource(
                     "Atom",
                    "https://campussuite-storage.s3.amazonaws.com/prod/1558520/74e5fec6-a2f9-11e7-8561-1206cd5ea310/1699406/3e8447c2-1331-11e8-a09a-0a7c05df476e/optimizations/512",
                  ),
                  _imageResource(
                  "DNA",
                    "https://www.otago.ac.nz/__data/assets/image/0014/321035/plastic-model-of-a-dna-helix-prints-using-a-3d-printer-714259.jpg",
                  ),
                  _imageResource(
                    "Optics", 
                    "https://effectuall.github.io/assets/screenshots/Optics_Diverging_Lens.jpg",
                  ),
        ],
      ),
    );
  }
  Widget _imageResource(String title, String imageUrl) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 40,
            ),
            child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(imageUrl, fit: BoxFit.cover, width: double.infinity, height: 150),
          ),
        ],
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
        '3D Science Resources',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
