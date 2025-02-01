import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:edigicator/pages/OnboardingPage.dart'; // Import OnboardingPage
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

class RegisterPageSyllabus extends StatefulWidget {
  const RegisterPageSyllabus({super.key});

  @override
  State<RegisterPageSyllabus> createState() => _RegisterPageSyllabusState();
}

class _RegisterPageSyllabusState extends State<RegisterPageSyllabus> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String selectedClass = "5th Standard"; // Default selection
  File? _profileImage;

  final List<String> classList = [
    "5th Standard",
    "6th Standard",
    "7th Standard",
    "8th Standard",
    "9th Standard",
    "10th Standard",
    "11 Standard",
    "12 Standard"
  ];

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _registerUser(BuildContext context) async {
    try {
      var uri = Uri.parse("http://localhost:8000/api/users/register");

      var request = http.MultipartRequest('POST', uri);

      // Profile image
      if (_profileImage != null) {
        var profileImage = await http.MultipartFile.fromPath(
          'profileImage', _profileImage!.path,
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(profileImage);
      }

      // Register user details
      request.fields['fullName'] = nameController.text;
      request.fields['mobile'] = phoneController.text; // Using phoneNumber
      request.fields['username'] = usernameController.text;
      request.fields['password'] = passwordController.text;
      request.fields['userClass'] = selectedClass;

      var response = await request.send();

      if (response.statusCode == 201) {
        // On success, navigate to OnboardingPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingPage()),
        );
      } else {
        print('Registration failed: ${response.statusCode}');
        // Display error message (can be improved with a UI)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Error: $e');
      // Display error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.center,
          child: Text(
            'Register',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: selectedClass,
              onChanged: (String? newValue) {
                setState(() {
                  selectedClass = newValue!;
                });
              },
              items: classList
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text("Pick Profile Image"),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => _registerUser(context),
                child: const Text('Register', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
