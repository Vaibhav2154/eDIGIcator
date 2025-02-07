import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor:  const Color.fromARGB(255, 255, 0, 0),
    
  ),
  textTheme: GoogleFonts.latoTextTheme().apply(
    bodyColor: Colors.white, // Set body text color to white
    displayColor: Colors.white, // Set display text color to white
  )
);