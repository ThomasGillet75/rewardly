import 'package:flutter/material.dart';
import 'package:rewardly/presentation/screen/home-page-screen.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const HomePageScreen(
              title: "Rewardly",
            ),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        primaryColor: const Color(0xFFECF0F1),
        useMaterial3: true,
      ),
    );
  }
}
