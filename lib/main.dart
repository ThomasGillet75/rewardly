import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rewardly/Application%20Layer/bloc/task/task_bloc.dart';
import 'package:rewardly/Application%20Layer/bloc/toggle/toggle_bloc.dart';
import 'package:rewardly/Application%20Layer/presentation/screen/home-page-screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TaskBloc()),
        BlocProvider(create: (context) => ToggleBloc()),
      ],
      child: MaterialApp(
        routes: {
          '/': (context) => const HomePageScreen(
            title: "Rewardly",
          ),
        },
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFA8D2A8)),
          primaryColor: const Color(0xFFECF0F1),
          useMaterial3: true,
        ),
      ),
    );
  }
}
