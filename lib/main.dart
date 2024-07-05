import 'package:flutter/material.dart';
import 'package:whispr/pages/intro_page.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whispr',

      // The app theme
      theme: ThemeData(
        useMaterial3: true,
        // General font
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xffff4165),
          primary: const Color(0xffff4165),
          secondary: const Color(0xfffffefe),
          brightness: Brightness.light,
        ),

        //Scaffold theme
        scaffoldBackgroundColor: const Color(0xfff1f1f1),
        //AppBar theme
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Color(0xffff4165),
          ),
        ),
        textTheme: const TextTheme(
          // Small title theme
          titleSmall: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),

          // Medium title theme
          titleMedium: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),

          // Large title theme
          titleLarge: TextStyle(
            fontSize: 55,
            fontFamily: 'Pacifico',
            color: Color(0xfffffefe),
          ),
        ),

        //Button theme
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: const Color(0xffff4165), // Button background color
            foregroundColor: const Color(0xfffffefe), // Button foreground color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
      ),
      home: const IntroPage(),
    );
  }
}
