import 'package:flutter/material.dart';
import 'features/turn_on/turnon_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remote Controller',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE5574E)),
        useMaterial3: true,
      ),
      home: const TurnOnPage(),
    );
  }
}
