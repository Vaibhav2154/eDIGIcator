import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:edigicator/pages/OnboardingPage.dart'; // Import OnboardingPage
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';

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

  Future<void> _registerUser() async {
    try {
      var uri = Uri.parse("http://localhost:8000/api/users/register");

      var request = http.MultipartRequest('POST', uri);

      if (_profileImage != null) {
        var profileImage = await http.MultipartFile.fromPath(
            'profileImage', _profileImage!.path,
            contentType: MediaType('image', 'jpeg'));

        request.files.add(profileImage);
      }

      request.fields['fullName'] = nameController.text;
      request.fields['email'] = phoneController.text; // Adjust as needed
      request.fields['username'] = usernameController.text;
      request.fields['password'] = passwordController.text;
      request.fields['userClass'] = selectedClass;

      var response = await request.send();
if (response.statusCode == 201 && mounted) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const OnboardingPage()),
  );
}

else {
        // Show error
        print('Failed to register: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Profile Picture Upload
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : null,
                  child: _profileImage == null
                      ? const Icon(Icons.camera_alt, size: 50)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Full Name
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 15),
            // Class Studying In (Dropdown)
            DropdownButtonFormField<String>(
              value: selectedClass,
              items: classList.map((className) {
                return DropdownMenuItem(
                  value: className,
                  child: Text(className),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedClass = value!;
                });
              },
              decoration: InputDecoration(
                labelText: "Class Studying In",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Phone Number
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 15),
            // Username
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
            // New Password
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 30),
            // Register Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _registerUser,
                child: const Text('Register', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
