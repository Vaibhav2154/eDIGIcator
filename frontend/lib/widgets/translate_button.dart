import 'package:flutter/material.dart';
import '../services/translation_service.dart';

class TranslateButton extends StatefulWidget {
  final String initialText;

  TranslateButton({required this.initialText});

  @override
  _TranslateButtonState createState() => _TranslateButtonState();
}

class _TranslateButtonState extends State<TranslateButton> {
  String translatedText = "";
  bool isKannada = false;

  @override
  void initState() {
    super.initState();
    translatedText = widget.initialText; // Initial text from parent
  }

  // Function to translate to Kannada
  void _translateToKannada() async {
    String result = await TranslationService.translateText(translatedText, "kn");
    setState(() {
      translatedText = result;
      isKannada = true;
    });
  }

  // Function to translate to English
  void _translateToEnglish() async {
    String result = await TranslationService.translateText(translatedText, "en");
    setState(() {
      translatedText = result;
      isKannada = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(translatedText, style: TextStyle(fontSize: 20)),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: isKannada ? _translateToEnglish : _translateToKannada,
          child: Text(isKannada ? "Switch to English" : "Switch to Kannada"),
        ),
      ],
    );
  }
}




