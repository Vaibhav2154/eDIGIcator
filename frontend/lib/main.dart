import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:edigicator/pages/loginpage.dart';
void main() {
  runApp(const App());
}
final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: const Color.fromARGB(255, 243, 170, 220),
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: const LoginPage(),
    );
  }
}