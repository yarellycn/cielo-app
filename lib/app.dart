import 'package:cielo_app/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CieloApp extends StatelessWidget {
  const CieloApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cielo',
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 55, 162, 216),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
