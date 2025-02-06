import 'package:edigicator/services/gemini_service.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:edigicator/services/language_provider.dart'; // Ensure this path is correct
import 'package:edigicator/services/translation_service.dart'; // Ensure this path is correct

class ChatScreen extends ConsumerStatefulWidget {

   @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
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
      final String translatedResponse = await _translateResponse(response);
      setState(() {
        _messages.add(Message(text: translatedResponse, isUser: false));
      });
    } catch (e) {
      setState(() {
        _messages.add(Message(text: 'Error: $e', isUser: false));
      });
    }
  }

  Future<String> _translateResponse(String response) async {
    final String currentLanguage = ref.watch(languageProvider);
    if (currentLanguage == "kn") {
      // Translate the response to Kannada
      return await TranslationService.translateText(response, "kn");
    }
    return response; // Return the original response if the language is English
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
          content: Text(getTranslatedText(
            'Permission to access photos is permanently denied. Please enable it in settings.',
            'ಫೋಟೋಗಳನ್ನು ಪ್ರವೇಶಿಸಲು ಅನುಮತಿಯನ್ನು ಶಾಶ್ವತವಾಗಿ ನಿರಾಕರಿಸಲಾಗಿದೆ. ದಯವಿಟ್ಟು ಅದನ್ನು ಸೆಟ್ಟಿಂಗ್ಸ್‌ನಲ್ಲಿ ಸಕ್ರಿಯಗೊಳಿಸಿ.',
          )),
          action: SnackBarAction(
            label: getTranslatedText('Settings', 'ಸೆಟ್ಟಿಂಗ್ಸ್'),
            onPressed: () {
              openAppSettings(); // Open app settings to allow the user to grant permission manually
            },
          ),
        ),
      );
    } else {
      // Handle other cases (e.g., permission denied)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(getTranslatedText(
            'Permission to access photos is required!',
            'ಫೋಟೋಗಳನ್ನು ಪ್ರವೇಶಿಸಲು ಅನುಮತಿ ಅಗತ್ಯವಿದೆ!',
          )),
        ),
      );
    }
  }

  // Function to translate text dynamically
  String getTranslatedText(String enText, String knText) {
    final String currentLanguage = ref.watch(languageProvider);
    return currentLanguage == "kn" ? knText : enText;
  }

  @override
  Widget build(BuildContext context) {
    final String currentLanguage = ref.watch(languageProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          getTranslatedText('eDigiBot', 'ಇಡಿಜಿಬಾಟ್'),
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          DropdownButton<String>(
            icon: const Icon(Icons.language),
            value: currentLanguage == "en" ? "English" : "Kannada",
            onChanged: (String? newValue) {
              final newLanguageCode = newValue == "English" ? "en" : "kn";
              ref.read(languageProvider.notifier).state = newLanguageCode;
            },
            items: <String>['English', 'Kannada']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
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
                      hintText: getTranslatedText('Type a message...', 'ಸಂದೇಶವನ್ನು ಟೈಪ್ ಮಾಡಿ...'),
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