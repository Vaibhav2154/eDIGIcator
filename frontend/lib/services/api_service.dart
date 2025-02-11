import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
  final apiServiceProvider = Provider((ref) => ApiService());
class ApiService {
  final String baseUrl = "http://10.0.2.2:8000/api";

  Future<List<Map<String, dynamic>>> fetchModules(int classNumber, String subject) async {
    // Ensure the subject is URL-safe
    String formattedSubject = Uri.encodeComponent(subject.toLowerCase());
    
    // Remove the hardcoded "1" from the URL
    final response = await http.get(
      Uri.parse("$baseUrl/videos/$classNumber/$formattedSubject")
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => {
        "title": item["title"],
        "videoUrl": item["videoUrl"],
        "module": item["module"] // Include module number
      }).toList();
    } else {
      throw Exception("❌ Failed to fetch modules: ${response.statusCode}");
    }
  }
}