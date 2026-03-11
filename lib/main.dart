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
        // Apple Blue als primaire kleur
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF007AFF),
          surface: Colors.white,
          brightness: Brightness.light,
        ),
        // De typische iOS lichtgrijze achtergrond
        scaffoldBackgroundColor: const Color(0xFFF2F2F7),
        useMaterial3: true,
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        // Transparante AppBars voor een cleanere look
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF2F2F7),
          surfaceTintColor: Colors.transparent,
        ),
      ),
      home: const EventListScreen(),
    );
  }
}
