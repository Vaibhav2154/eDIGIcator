import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class GeminiService {
  final String apiKey;
  final String apiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent";

  GeminiService(this.apiKey);

  Future<String> sendMessageWithImage(String message, File? imageFile) async {
    List<Map<String, dynamic>> parts = [];

    // Add text part
    if (message.isNotEmpty) {
      parts.add({"text": message});
    }

    // Add image part if an image is provided
    if (imageFile != null) {
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      parts.add({
        "inlineData": {
          "mimeType": "image/jpeg", // Adjust MIME type based on the image format
          "data": base64Image,
        }
      });
    }

    final response = await http.post(
      Uri.parse('$apiUrl?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {"parts": parts}
        ]
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['candidates'][0]['content']['parts'][0]['text'];
    } else {
      throw Exception('Failed to load response: ${response.body}');
    }
  }
}