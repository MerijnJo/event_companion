import 'package:flutter/material.dart';
import 'screens/event_list_screen.dart';

void main() {
  runApp(const EventCompanionApp());
}

class EventCompanionApp extends StatelessWidget {
  const EventCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Companion',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4E45E4),
          surface: const Color(0xFFFCF8FE),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFFCF8FE),
        useMaterial3: true,
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFCF8FE),
          surfaceTintColor: Colors.transparent,
        ),
      ),
      home: const EventListScreen(),
    );
  }
}
