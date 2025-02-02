import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:edigicator/services/language_provider.dart'; // Import the language provider

class CompetitiveExamScreen extends ConsumerStatefulWidget {
  @override
  _CompetitiveExamScreenState createState() => _CompetitiveExamScreenState();
}

class _CompetitiveExamScreenState extends ConsumerState<CompetitiveExamScreen> {
  final DateTime examDate = DateTime(2025, 5, 15); // Set your exam date

  int getDaysLeft() {
    final now = DateTime.now();
    return examDate.difference(now).inDays;
  }

  void _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  String getTranslatedText(String enText, String knText) {
    final String currentLanguage = ref.read(languageProvider);
    return currentLanguage == "kn" ? knText : enText;
  }

  @override
  Widget build(BuildContext context) {
    final String currentLanguage = ref.watch(languageProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          getTranslatedText("eDigiEdu Mitra", "ಇಡಿಜಿಎಜು ಮಿತ್ರ"),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Days Left Bar
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 149, 172, 212),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getTranslatedText("Days Left: ", "ಉಳಿದ ದಿನಗಳು: "),
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${getDaysLeft()} ${getTranslatedText("Days", "ದಿನಗಳು")}",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Resources Section
            Text(
              getTranslatedText("Resources", "ಸಂಪನ್ಮೂಲಗಳು"),
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  _imageResource(
                    getTranslatedText("Physics Formulas", "ಭೌತಶಾಸ್ತ್ರ ಸೂತ್ರಗಳು"),
                    "https://wallpapers.com/images/hd/physics-equations-background-c7egouj6ncclh5dn.jpg",
                  ),
                  _imageResource(
                    getTranslatedText("Chemistry", "ರಸಾಯನಶಾಸ್ತ್ರ"),
                    "https://media.getmyuni.com/assets/images/articles/0eits6n-41u02l1n392dd-5eig7t.jpg",
                  ),
                  _imageResource(
                    getTranslatedText("Mathematics", "ಗಣಿತ"),
                    "https://static.vecteezy.com/system/resources/previews/005/421/417/non_2x/maths-symbols-icon-set-algebra-or-mathematics-subject-doodle-design-education-and-study-concept-back-to-school-background-for-notebook-not-pad-sketchbook-hand-drawn-illustration-vector.jpg",
                  ),
                  SizedBox(height: 20),
                  Text(
                    getTranslatedText("Visual Study Materials", "ದೃಶ್ಯ ಅಧ್ಯಯನ ಸಾಮಗ್ರಿಗಳು"),
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  _resourceTile(
                    getTranslatedText("JEE Main Official Website", "ಜೆಇಇ ಮುಖ್ಯ ಅಧಿಕೃತ ವೆಬ್ಸೈಟ್"),
                    "https://jeemain.nta.ac.in",
                  ),
                  _resourceTile(
                    getTranslatedText("NEET Official Website", "ನೀಟ್ ಅಧಿಕೃತ ವೆಬ್ಸೈಟ್"),
                    "https://neet.nta.nic.in",
                  ),
                  _resourceTile(
                    getTranslatedText("UPSC Preparation Guide", "ಯುಪಿಎಸ್ಸಿ ತಯಾರಿ ಮಾರ್ಗದರ್ಶಿ"),
                    "https://www.upsc.gov.in",
                  ),
                  _resourceTile(
                    getTranslatedText("Previous Year Papers", "ಹಿಂದಿನ ವರ್ಷದ ಪ್ರಶ್ನೆ ಪತ್ರಿಕೆಗಳು"),
                    "https://www.examrace.com",
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _resourceTile(String title, String url) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        subtitle: Text(url, style: TextStyle(color: Colors.blue)),
        trailing: Icon(Icons.open_in_new, color: Colors.blueAccent),
        onTap: () => _launchURL(url),
      ),
    );
  }

  Widget _imageResource(String title, String imageUrl) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(imageUrl, fit: BoxFit.cover, width: double.infinity, height: 150),
          ),
        ],
      ),
    );
  }
}