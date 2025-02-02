import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class GeminiApiService {
  final String apiKey;
  final String baseUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro-vision:generateContent";

  GeminiApiService({required this.apiKey});

  Future<String> generateModuleWiseQuestions({
    required int classLevel,
    required String subject,
    required String chapter,
  }) async {
    String prompt =
        "Generate 5 questions for Class $classLevel, Subject: $subject, Chapter: $chapter, based on the NCERT syllabus.";

    Map<String, dynamic> requestBody = {
      "contents": [
        {
          "parts": [
            {"text": prompt}
          ]
        }
      ]
    };

    final response = await http.post(
      Uri.parse("https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final generatedText = jsonResponse['candidates'][0]['content']['parts'][0]['text'];
      return generatedText;
    } else {
      throw Exception("Failed to generate questions: ${response.body}");
    }
  }

  Future<String> generateFinalExamQuestions({required int classLevel}) async {
    String prompt =
        "Generate a full-length question paper for Class $classLevel based on the NCERT syllabus. "
        "Include a mix of subjects like Mathematics, Science, Social Science, and English. "
        "Cover all major chapters and topics.";

    Map<String, dynamic> requestBody = {
      "contents": [
        {
          "parts": [
            {"text": prompt}
          ]
        }
      ]
    };

    final response = await http.post(
      Uri.parse("https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final generatedText = jsonResponse['candidates'][0]['content']['parts'][0]['text'];
      return generatedText;
    } else {
      throw Exception("Failed to generate questions: ${response.body}");
    }
  }

  Future<String> analyzeAnswerImage({required String imagePath, required String question}) async {
    // Read the image file as bytes
    List<int> imageBytes = await File(imagePath).readAsBytes();
    String base64Image = base64Encode(imageBytes);

    // Define the prompt for the Gemini API
    String prompt =
        "Analyze the uploaded image containing the answer to the following question: '$question'. "
        "Provide detailed feedback on the correctness of the answer, suggest improvements, and highlight any errors.";

    // Prepare the request body
    Map<String, dynamic> requestBody = {
      "contents": [
        {
          "parts": [
            {"text": prompt},
            {"inline_data": {"mime_type": "image/jpeg", "data": base64Image}}
          ]
        }
      ]
    };

    // Make the HTTP POST request
    final response = await http.post(
      Uri.parse("$baseUrl?key=$apiKey"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestBody),
    );

    // Parse the response
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final feedback = jsonResponse['candidates'][0]['content']['parts'][0]['text'];
      return feedback;
    } else {
      throw Exception("Failed to analyze answer: ${response.body}");
    }
  }
}