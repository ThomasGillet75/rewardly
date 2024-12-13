import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rewardly/Application%20Layer/bloc/task/task_bloc.dart';
import 'package:rewardly/Application%20Layer/bloc/toggle/toggle_bloc.dart';
import 'package:rewardly/Application%20Layer/presentation/screen/home-page-screen.dart';
import 'package:rewardly/Application%20Layer/presentation/screen/sign_in_page_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import 'Application Layer/presentation/screen/sign_up_page_screen.dart';
import 'Data/models/user.dart';

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
          debugShowCheckedModeBanner: false,
          title: 'Flutter Firebase Auth',
          home: AuthWrapper(),
          routes: {
            '/home': (context) => const HomePageScreen(title: 'rewardly'),
            '/signIn': (context) => SignInPage(),
            '/signUp': (context) => SignUpPage(),
          },
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFA8D2A8)),
            primaryColor: const Color(0xFFECF0F1),
            useMaterial3: true,
          ),
        ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final firebase_auth.User? user = FirebaseAuth.instance.currentUser;
    // Navigate based on auth state
    if (user != null) {
     return const HomePageScreen(title: 'Rewardly');
    } else {
      return SignInPage();
    }
  }
}

