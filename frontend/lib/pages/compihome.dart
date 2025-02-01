import 'package:flutter/material.dart';

class Compihome extends StatelessWidget {
  const Compihome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // To remove the back button
        title: const Text(
          'Hello student', // Title of the AppBar
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // "Welcome" Text below the AppBar
            const Text(
              'Welcome to the Competitive Exams Section!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Add any other widgets or content you want to show on the page
            const Text(
              'Here you can explore various resources to help you prepare for competitive exams.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            // You can add buttons, images, or any other content below
          ],
        ),
      ),
    );
  }
}
