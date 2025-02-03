import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LatestNewsPage extends StatefulWidget {
  const LatestNewsPage({super.key});

  @override
  State<LatestNewsPage> createState() => _LatestNewsPageState();
}

class _LatestNewsPageState extends State<LatestNewsPage> {
  int _selectedIndex = 0; // Selected category index
  int _page = 1; // Pagination page
  bool _isLoading = false; // Loading state
  final List<dynamic> _articles = []; // List of news articles

  // Categories for news
  final List<String> categories = ["", "external", "sports", "technology", "education"];

  // Gemini API details
  final String geminiApiUrl = "https://api.gemini.com/v1/news/latest"; // Replace with actual Gemini API endpoint
  final String geminiApiKey = "AIzaSyC5I3IvJ_QnEsb28ncuwRgauLCwFLtp6pk"; // Replace with your Gemini API key

  @override
  void initState() {
    super.initState();
    _fetchNews(); // Fetch news when the page loads
  }

  // Fetch news from Gemini API
  Future<void> _fetchNews() async {
  if (_isLoading) return;

  setState(() {
    _isLoading = true;
  });

  try {
    final response = await http.get(
      Uri.parse(geminiApiUrl),
      headers: {
        'Authorization': 'Bearer $geminiApiKey',
      },
    );

    print("API Response Status Code: ${response.statusCode}"); // Debug: Log status code
    print("API Response Body: ${response.body}"); // Debug: Log response body

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final String selectedCategory = categories[_selectedIndex];
      final filteredData = data.where((article) => article['category'] == selectedCategory).toList();

      setState(() {
        _articles.addAll(filteredData);
        _page++;
      });
    } else {
      throw Exception('Failed to load news');
    }
  } catch (e) {
    print("Error: $e"); // Debug: Log the full error
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}

  // Handle category change
  void _onCategoryChanged(int index) {
    setState(() {
      _selectedIndex = index; // Update selected category
      _articles.clear(); // Clear existing articles
      _page = 1; // Reset pagination
    });
    _fetchNews(); // Fetch news for the new category
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categories[_selectedIndex].toUpperCase()), // Display selected category
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          // Load more news when the user scrolls to the bottom
          if (!_isLoading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            _fetchNews();
          }
          return false;
        },
        child: ListView.builder(
          itemCount: _articles.length + 1, // Add 1 for the loading indicator
          itemBuilder: (context, index) {
            if (index == _articles.length) {
              // Show loading indicator at the bottom
              return _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : const SizedBox();
            }

            // Display news article
            final article = _articles[index];
            return Card(
              margin: const EdgeInsets.all(8),
              elevation: 3,
              child: ListTile(
                title: Text(article['title'] ?? 'No Title'), // Article title
                subtitle: Text(article['content'] ?? 'No Description'), // Article content
                leading: const Icon(Icons.article), // Article icon
                onTap: () {
                  // Handle article tap (e.g., open full article)
                },
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onCategoryChanged, // Handle category change
        items: categories
            .map((category) => BottomNavigationBarItem(
                  icon: const Icon(Icons.article),
                  label: category.toUpperCase(),
                ))
            .toList(),
      ),
    );
  }
}