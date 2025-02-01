import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslationService {
  static const String _apiKey = "AIzaSyDUeXKqynr7Pu0hFNnNOLmNrpROYG5Jl6g";
  static const String _baseUrl = "https://translation.googleapis.com/language/translate/v2";

  static Future<String> translateText(String text, String targetLanguage) async {
    final Uri uri = Uri.parse("$_baseUrl?key=$_apiKey");

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "q": text,
        "target": targetLanguage,
        "format": "text",
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse['data']['translations'][0]['translatedText'];
    } else {
      throw Exception("Failed to translate text");
    }
  }
}