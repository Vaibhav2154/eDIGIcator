import 'package:edigicator/pages/subjects/question_generator_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:edigicator/pages/subjects/englishhome.dart';
import 'package:edigicator/pages/subjects/kannadahome.dart';
import 'package:edigicator/pages/subjects/socialhome.dart';
import 'package:edigicator/pages/subjects/sciencehome.dart';
import 'package:edigicator/pages/subjects/mathshome.dart';
import 'package:edigicator/services/language_provider.dart';

class Subjectselection extends ConsumerWidget {
  final int selectedClass; // Receive class number

  const Subjectselection({super.key, required this.selectedClass});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String currentLanguage = ref.watch(languageProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          'Class $selectedClass Subjects',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              getTranslatedText(
                ref,
                'Welcome to Class $selectedClass Syllabus!',
                'ಶ್ರೇಣಿಯ $selectedClass ಪಠ್ಯಕ್ರಮಕ್ಕೆ ಸ್ವಾಗತ!',
              ),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 1.0,
                children: [
                  SubjectCard(
                    title: getTranslatedText(ref, 'English', 'ಇಂಗ್ಲಿಷ್'),
                    icon: Icons.language,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EnglishHome(
                            selectedClass: selectedClass,
                            subject: 'English', // Pass subject parameter
                          ),
                        ),
                      );
                    },
                  ),
                  SubjectCard(
                    title: getTranslatedText(ref, 'Kannada', 'ಕನ್ನಡ'),
                    icon: Icons.language_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => KannadaHome(
                            selectedClass: selectedClass,
                            subject: 'Kannada', // Pass subject parameter
                          ),
                        ),
                      );
                    },
                  ),
                  SubjectCard(
                    title: getTranslatedText(ref, 'Social', 'ಸಮಾಜಶಾಸ್ತ್ರ'),
                    icon: Icons.school,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SocialHome(
                            selectedClass: selectedClass,
                            subject: 'Social', // Pass subject parameter
                          ),
                        ),
                      );
                    },
                  ),
                  SubjectCard(
                    title: getTranslatedText(ref, 'Science', 'ವಿಜ್ಞಾನ'),
                    icon: Icons.science,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScienceHome(
                            selectedClass: selectedClass,
                            subject: 'Science', // Pass subject parameter
                          ),
                        ),
                      );
                    },
                  ),
                  SubjectCard(
                    title: getTranslatedText(ref, 'Maths', 'ಗಣಿತ'),
                    icon: Icons.calculate,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MathsHome(
                            selectedClass: selectedClass,
                            subject: 'Mathematics', // Pass subject parameter
                          ),
                        ),
                      );
                    },
                  ),
                  SubjectCard(
                    title: getTranslatedText(ref, 'Exam Prep','Exam Prep'),
                    icon: Icons.calculate,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuestionGeneratorScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getTranslatedText(WidgetRef ref, String enText, String knText) {
    final String currentLanguage = ref.watch(languageProvider);
    return currentLanguage == "kn" ? knText : enText;
  }
}

class SubjectCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const SubjectCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.blueAccent,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 50.0,
                color: Colors.white,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
