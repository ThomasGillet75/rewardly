import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rewardly/Application%20Layer/bloc/project/project_bloc.dart';
import 'package:rewardly/Application%20Layer/bloc/task/task_bloc.dart';
import 'package:rewardly/Application%20Layer/bloc/toggle/toggle_bloc.dart';
import 'package:rewardly/Application%20Layer/presentation/screen/home-page-screen.dart';
import 'package:rewardly/Application%20Layer/presentation/screen/project_page_screen.dart';
import 'package:rewardly/Application%20Layer/presentation/screen/sign_in_page_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:rewardly/Data/models/project_entity.dart';
import 'package:rewardly/core/color.dart';

import 'Application Layer/bloc/signin/sign_in_bloc.dart';
import 'Application Layer/bloc/signup/sign_up_bloc.dart';
import 'Application Layer/presentation/screen/sign_up_page_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}


final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => TaskBloc()),
          BlocProvider(create: (context) => ToggleBloc()),
          BlocProvider(create: (context) => ProjectBloc()),
          BlocProvider(create: (context) => SignUpBloc()),
          BlocProvider(create: (context) => SignInBloc()),
        ],
        child: MaterialApp(
          navigatorObservers: [routeObserver],
          debugShowCheckedModeBanner: false,
          title: 'Flutter Firebase Auth',
          home: AuthWrapper(),
          routes: {
            '/home': (context) => const HomePageScreen(title: 'Rewardly'),
            '/signIn': (context) => SignInPage(),
            '/signUp': (context) => SignUpPage(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/projectPage') {
              final project = settings.arguments as Project;
              return MaterialPageRoute(
                builder: (context) => ProjectPageScreen(project: project),
              );
            }
            return null;
          },
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary ),
            primaryColor: const Color(0xFFECF0F1),
            useMaterial3: true,
            scaffoldBackgroundColor: AppColors.background,
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

