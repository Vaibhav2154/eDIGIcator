import 'package:flutter/material.dart';
import 'package:edigicator/pages/authentication/RegisterPageComp.dart';
//import 'package:edigicator/pages/authentication/registerpagesyllabus.dart';
import 'package:edigicator/pages/authentication/RegisterPageSyllabus.dart';
class RegisterSelectionPage extends StatefulWidget {
  const RegisterSelectionPage({super.key});

  @override
  State<RegisterSelectionPage> createState() => _RegisterSelectionPageState();
}

class _RegisterSelectionPageState extends State<RegisterSelectionPage> {
  String selectedType = "Competitive Exam Student"; // Default selection

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Student Type")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Are you a:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            const SizedBox(height: 20),

            // Radio Button for Competitive Exam Student
            RadioListTile<String>(
              title: const Text("Competitive Exam Student"),
              value: "Competitive Exam Student",
              groupValue: selectedType,
              onChanged: (value) {
                setState(() {
                  selectedType = value!;
                });
              },
            ),

            // Radio Button for Syllabus Exam Student
            RadioListTile<String>(
              title: const Text("Syllabus Exam Student"),
              value: "Syllabus Exam Student",
              groupValue: selectedType,
              onChanged: (value) {
                setState(() {
                  selectedType = value!;
                });
              },
            ),

            const SizedBox(height: 30),

            // Continue Button to navigate to respective page
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (selectedType == "Competitive Exam Student") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  RegisterPageComp()),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  RegisterPageSyllabus()),
                    );
                  }
                },
                child: const Text("Continue", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
