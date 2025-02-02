import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class ResourcesPage extends StatefulWidget {
  final int selectedClass;
  final String subject;

  const ResourcesPage({super.key, required this.selectedClass, required this.subject});

  @override
  _ResourcesPageState createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  String? textbookLink;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTextbookLink();
  }

  Future<void> _fetchTextbookLink() async {
    try {
      final response = await http.get(Uri.parse('https://drive.google.com/file/d/19SvsZiyCYV-Z4yeKd4vE4yGS1bAjnAzC/view?usp=sharing'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          textbookLink = data['textbookLink']; // Ensure this key exists in your API response
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load textbook link');
      }
    } catch (e) {
      print("Error fetching textbook link: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _launchURL() async {
    if (textbookLink != null && await canLaunch(textbookLink!)) {
      await launch(textbookLink!);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not open link")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isLoading
          ? CircularProgressIndicator()
          : textbookLink != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${widget.subject} Resources for Class ${widget.selectedClass}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _launchURL,
                      child: Text("Open Textbook"),
                    ),
                  ],
                )
              : Text("Textbook link not available"),
    );
  }
}
