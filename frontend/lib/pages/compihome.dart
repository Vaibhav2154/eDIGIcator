import 'package:flutter/material.dart';
import 'package:edigicator/pages/jeehome.dart';
import 'package:edigicator/pages/kcethome.dart';
class Compihome extends StatelessWidget {
  const Compihome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:true, // To remove the back button
        title: const Text(
          'Hello student', // Title of the AppBar
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // Keep content aligned to the top
          crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
          children: [
            // "Welcome" Text moved to the top of the page
            const Text(
              'Welcome to the Competitive Exams Section!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Centering the column of images
            Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center the images vertically
              children: [
                // KCET Image with Text
                GestureDetector(
                  onTap: () {
                    // Navigate to KCET Home
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const KceHome()),
                    );
                  },
                  child: Column(
                    children: [
                      Image.asset('assets/competitve.jpg', height: 120), // KCET Image
                      const SizedBox(height: 8),
                      const Text(
                        'KCET', 
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20), // Space between images
                // JEE Image with Text
                GestureDetector(
                  onTap: () {
                    // Navigate to JEE Home
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const JeeHome()),
                    );
                  },
                  child: Column(
                    children: [
                      Image.asset('assets/syllabus.jpg', height: 120), // JEE Image
                      const SizedBox(height: 8),
                      const Text(
                        'JEE',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
}

// Example KceHome Page

// Example JeeHome Page
