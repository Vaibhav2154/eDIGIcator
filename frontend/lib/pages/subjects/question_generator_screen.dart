import 'dart:io';
import 'package:edigicator/services/gemini_api_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class QuestionGeneratorScreen extends StatefulWidget {
  @override
  _QuestionGeneratorScreenState createState() => _QuestionGeneratorScreenState();
}

class _QuestionGeneratorScreenState extends State<QuestionGeneratorScreen> {
  int selectedClass = 5;
  String selectedMode = "Module-Wise Practice"; // Default mode
  String selectedSubject = "Mathematics";
  String selectedChapter = "Algebra";
  String generatedQuestions = "";
  String feedback = "";
  bool isLoading = false;
  File? uploadedImage;

  final GeminiApiService geminiApiService = GeminiApiService(apiKey: "AIzaSyC5I3IvJ_QnEsb28ncuwRgauLCwFLtp6pk");

  Future<void> _generatePaper() async {
    setState(() {
      isLoading = true;
      generatedQuestions = "";
      feedback = "";
    });

    try {
      if (selectedMode == "Module-Wise Practice") {
        // Generate module-wise questions
        final result = await geminiApiService.generateModuleWiseQuestions(
          classLevel: selectedClass,
          subject: selectedSubject,
          chapter: selectedChapter,
        );
        setState(() {
          generatedQuestions = result;
          isLoading = false;
        });
      } else if (selectedMode == "Final Exam Preparation") {
        // Generate full-length exam questions
        final result = await geminiApiService.generateFinalExamQuestions(classLevel: selectedClass);
        setState(() {
          generatedQuestions = result;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        generatedQuestions = "Error: Unable to generate questions. Please try again.";
        isLoading = false;
      });
    }
  }

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        uploadedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _analyzeAnswer(String question) async {
    if (uploadedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please upload an image first.")));
      return;
    }

    setState(() {
      isLoading = true;
      feedback = "";
    });

    try {
            // Call the Gemini API to analyze the uploaded image
      final result = await geminiApiService.analyzeAnswerImage(
        imagePath: uploadedImage!.path,
        question: question,
      );

      setState(() {
        feedback = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        feedback = "Error: Unable to analyze answer. Please try again.";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Align(
        alignment:  Alignment.center,
        child: Scaffold(
          appBar: AppBar(
            title: Align(
              alignment: Alignment.center,
              child: Text(
                'eDigiEdu Mitra',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButton<String>(
                  value: selectedMode,
                  items: ["Module-Wise Practice", "Final Exam Preparation"]
                      .map((mode) => DropdownMenuItem(
                            value: mode,
                            child: Text(mode),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedMode = value!;
                    });
                  },
                ),
                SizedBox(height: 20),
                if (selectedMode == "Module-Wise Practice")
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Select Subject"),
                      DropdownButton<String>(
                        value: selectedSubject,
                        items: ["Mathematics", "Science", "Social Science", "English"]
                            .map((subject) => DropdownMenuItem(
                                  value: subject,
                                  child: Text(subject),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedSubject = value!;
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      Text("Select Chapter"),
                      DropdownButton<String>(
                        value: selectedChapter,
                        items: _getChaptersForSubject(selectedSubject)
                            .map((chapter) => DropdownMenuItem(
                                  value: chapter,
                                  child: Text(chapter),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedChapter = value!;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _generatePaper,
                        child: Text('Generate Question Paper'),
                      ),
                      if (generatedQuestions.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            Text(
                              "Generated Questions",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(
                              generatedQuestions,
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _uploadImage,
                              child: Text('Upload Answer Image'),
                            ),
                            if (uploadedImage != null)
                              Column(
                                children: [
                                  SizedBox(height: 10),
                                  Image.file(uploadedImage!, height: 100),
                                  SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () => _analyzeAnswer(generatedQuestions.split("\n").first),
                                    child: Text('Analyze Answer'),
                                  ),
                                ],
                              ),
                            if (feedback.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 20),
                                  Text(
                                    "Feedback:",
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 10),
                                  Text(feedback, style: TextStyle(fontSize: 16)),
                                ],
                              ),
                          ],
                        ),
                    ],
                  ),
                if (selectedMode == "Final Exam Preparation")
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Select Class"),
                      DropdownButton<int>(
                        value: selectedClass,
                        items: List.generate(8, (index) => DropdownMenuItem(
                              value: index + 5,
                              child: Text('Class ${index + 5}'),
                            )),
                        onChanged: (value) {
                          setState(() {
                            selectedClass = value!;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _generatePaper,
                        child: Text('Generate Question Paper'),
                      ),
                      if (generatedQuestions.isNotEmpty)
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              generatedQuestions,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                    ],
                  ),
                if (isLoading)
                  Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper function to get chapters for a given subject
  List<String> _getChaptersForSubject(String subject) {
    switch (subject) {
      case "Mathematics":
        return ["Algebra", "Geometry", "Trigonometry"];
      case "Science":
        return ["Physics", "Chemistry", "Biology"];
      case "Social Science":
        return ["History", "Geography", "Civics"];
      case "English":
        return ["Grammar", "Literature", "Writing Skills"];
      default:
        return [];
    }
  }
}