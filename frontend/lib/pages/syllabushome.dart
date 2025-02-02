import 'package:flutter/material.dart';
import 'package:edigicator/pages/subjectselection.dart'; // Import the next page

class SyllabusHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Your Class'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Which class are you studying in?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            for (int i = 6; i <= 12; i++) ClassButton(classNumber: i),
          ],
        ),
      ),
    );
  }
}

class ClassButton extends StatelessWidget {
  final int classNumber;

  const ClassButton({required this.classNumber});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Subjectselection(selectedClass: classNumber),
            ),
          );
        },
        child: Text(
          'Class $classNumber',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
