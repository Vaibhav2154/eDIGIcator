import 'package:edigicator/services/gemini_service.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [];
  final GeminiService _geminiService = GeminiService('AIzaSyC5I3IvJ_QnEsb28ncuwRgauLCwFLtp6pk');
  File? _selectedImage;

  void _sendMessage(String text) async {
    if (text.isEmpty && _selectedImage == null) return;

    setState(() {
      _messages.add(Message(text: text, isUser: true, image: _selectedImage));
      _controller.clear();
      _selectedImage = null; // Clear the selected image after sending
    });

    try {
      final response = await _geminiService.sendMessageWithImage(text, _selectedImage);
      setState(() {
        _messages.add(Message(text: response, isUser: false));
      });
    } catch (e) {
      setState(() {
        _messages.add(Message(text: 'Error: $e', isUser: false));
      });
    }
  }

  Future<void> _pickImage() async {
  // Check and request permission to access photos
  PermissionStatus permissionStatus = await Permission.photos.request();

  if (permissionStatus.isGranted) {
    // Permission granted, proceed to pick an image
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    } else {
      print("No image selected.");
    }
  } else if (permissionStatus.isPermanentlyDenied) {
    // Handle permanently denied permissions
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Permission to access photos is permanently denied. Please enable it in settings.'),
        action: SnackBarAction(
          label: 'Settings',
          onPressed: () {
            openAppSettings(); // Open app settings to allow the user to grant permission manually
          },
        ),
      ),
    );
  } else {
    // Handle other cases (e.g., permission denied)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Permission to access photos is required!')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Align(          
          alignment: Alignment.center,
          child: Text(
            'eDigiBot',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 40,
            ),
          ),
        ),

      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: message.isUser ? Colors.blue[200] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (message.image != null)
                          Image.file(
                            message.image!,
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        SizedBox(height: 8),
                        Text(message.text),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.image),
                  onPressed: _pickImage,
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Message {
  final String text;
  final bool isUser;
  final File? image;

  Message({required this.text, required this.isUser, this.image});
}


