import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeVideoPlayerFlutter extends StatefulWidget {
  const YoutubeVideoPlayerFlutter({super.key});

  @override
  _YoutubeVideoPlayerFlutterState createState() => _YoutubeVideoPlayerFlutterState();
}

class _YoutubeVideoPlayerFlutterState extends State<YoutubeVideoPlayerFlutter> {
  late YoutubePlayerController playerController;
  bool isLoading = true;
  String? videoUrl; // Store the fetched YouTube video URL

  @override
  void initState() {
    super.initState();
    fetchVideoUrl(); // Fetch the video URL when the widget initializes
  }

  Future<void> fetchVideoUrl() async {
    var uri = Uri.parse("http://10.0.2.2:8000/api/videos/videos/8/Science/1");

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body); // API returns an array
        if (data.isNotEmpty) {
          setState(() {
            videoUrl = data[0]; // Assuming first URL is needed
            playerController = YoutubePlayerController(
              initialVideoId: YoutubePlayer.convertUrlToId(videoUrl!)!,
              flags: const YoutubePlayerFlags(
                autoPlay: true,
                mute: false,
              ),
            );
            isLoading = false;
          });
        } else {
          throw Exception("No videos found.");
        }
      } else {
        throw Exception("Failed to load video.");
      }
    } catch (e) {
      print("Error fetching video: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("YouTube Video Player")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loader while fetching
          : videoUrl == null
              ? const Center(child: Text("No video found"))
              : YoutubePlayer(
                  controller: playerController,
                  showVideoProgressIndicator: true,
                ),
    );
  }
}
