import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'username_screen.dart'; // Nayi file ka import

void main() {
  runApp(const LevoApp());
}

class LevoApp extends StatelessWidget {
  const LevoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LEVO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0C10),
        primaryColor: const Color(0xFF0052FF),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF0052FF),
          secondary: Color(0xFF00E5FF),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      ),
      home: const UsernameScreen(), // Ab direct Username screen khulegi
    );
  }
}
