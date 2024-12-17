import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rewardly/Application/bloc/friends/friends_bloc.dart';
import 'package:rewardly/Application/bloc/project/project_bloc.dart';
import 'package:rewardly/Application/bloc/signin/sign_in_bloc.dart';
import 'package:rewardly/Application/bloc/signup/sign_up_bloc.dart';
import 'package:rewardly/Application/bloc/task/task_bloc.dart';
import 'package:rewardly/Application/bloc/toggle/toggle_bloc.dart';
import 'package:rewardly/Application/presentation/screen/friends_page_screen.dart';
import 'package:rewardly/Application/presentation/screen/home-page-screen.dart';
import 'package:rewardly/Application/presentation/screen/project_page_screen.dart';
import 'package:rewardly/Application/presentation/screen/sign_in_page_screen.dart';
import 'package:rewardly/Application/presentation/screen/sign_up_page_screen.dart';
import 'package:rewardly/Core/color.dart';
import 'package:rewardly/Data/models/project_entity.dart';
import 'package:rewardly/Data/models/user_entity.dart';

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
        BlocProvider(create: (context) => FriendsBloc()),
      ],
      child: MaterialApp(
        navigatorObservers: [routeObserver],
        debugShowCheckedModeBanner: false,
        title: 'Flutter Firebase Auth',
        home: AuthWrapper(),
        routes: {
          '/home': (context) => const HomePageScreen(title: 'Rewardly'),
          '/signIn': (context) => SignInPage(),
          '/signUp': (context) => SignUpPage(users: Users.empty()),
          '/friends': (context) => FriendsPageScreen(),
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
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
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