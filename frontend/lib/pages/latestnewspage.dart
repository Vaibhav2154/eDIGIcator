import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LatestNewsPage extends StatefulWidget {
  const LatestNewsPage({super.key});

  @override
  State<LatestNewsPage> createState() => _LatestNewsPageState();
}

class _LatestNewsPageState extends State<LatestNewsPage> {
  int _selectedIndex = 0;
  int _page = 1;
  bool _isLoading = false;
  final List<dynamic> _articles = [];

  final List<String> categories = ["national", "external", "sports", "technology", "education"];
  final String baseUrl = "http://YOUR_SERVER_IP:PORT/api/news"; // Replace with your backend URL

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  // ✅ Fetch news from backend
  Future<void> _fetchNews() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    String category = categories[_selectedIndex];
    final url = Uri.parse("$baseUrl/$category"); // API Endpoint: /api/news/:category

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _articles.addAll(data);
          _page++;
        });
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // ✅ Change category when bottom navigation is tapped
  void _onCategoryChanged(int index) {
    setState(() {
      _selectedIndex = index;
      _articles.clear();
      _page = 1;
    });
    _fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(categories[_selectedIndex].toUpperCase())),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!_isLoading &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            _fetchNews();
          }
          return false;
        },
        child: ListView.builder(
          itemCount: _articles.length + 1,
          itemBuilder: (context, index) {
            if (index == _articles.length) {
              return _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : const SizedBox();
            }

            final article = _articles[index];
            return Card(
              margin: const EdgeInsets.all(8),
              elevation: 3,
              child: ListTile(
                title: Text(article['title'] ?? 'No Title'),
                subtitle: Text(article['content'] ?? 'No Description'),
                leading: const Icon(Icons.article),
                onTap: () {
                  // Handle news item tap (e.g., open full article)
                },
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onCategoryChanged,
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
