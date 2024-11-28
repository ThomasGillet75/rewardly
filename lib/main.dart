import 'package:flutter/material.dart';
import 'package:rewardly/presentation/screen/HomePageScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const HomePageScreen(title: "Rewardly",),
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        primaryColor: const Color(0xFFECF0F1),
        useMaterial3: true,
      ),
    );
  }
}

