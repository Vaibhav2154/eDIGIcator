import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;
  String wakeUpTime = "";
  String bedTime = "";
  String schoolTime = "";
  String videosWatched = "";
  String questionsAsked = "";
  String streak = "";
  String maxStreak = "";
  String totalQuestionsAnswered = "";

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/users/user/userStats'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          wakeUpTime = data['wakeUpTime'] ?? "N/A";
          bedTime = data['bedTime'] ?? "N/A";
          schoolTime = data['schoolTime'] ?? "N/A";
          videosWatched = data['videosWatched'].toString();
          questionsAsked = data['questionsAsked'].toString();
          streak = data['streak'].toString();
          maxStreak = data['maxStreak'].toString();
          totalQuestionsAnswered = data['totalQuestionsAnswered'].toString();
        });
      } else {
        throw Exception('Failed to load profile data');
      }
    } catch (e) {
      print("Error fetching profile data: $e");
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
           
            SizedBox(height: 20),
            _buildInfoCard("Wake-up Time",'6:30 AM' ),
            _buildInfoCard("Bed Time", '9:30 PM'),
            _buildInfoCard("School Time", '10:30 AM'),
            _buildInfoCard("Videos Watched", '3'),
            _buildInfoCard("Questions Asked", '4'),
            _buildInfoCard("Streak", '2'),
            _buildInfoCard("Max Streak", '3'),
            _buildInfoCard("Total Questions Answered", 'null'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        subtitle: Text(value.isNotEmpty ? value : "Loading...", style: TextStyle(fontSize: 14, color: Colors.grey[600])),
      ),
    );
  }
}
