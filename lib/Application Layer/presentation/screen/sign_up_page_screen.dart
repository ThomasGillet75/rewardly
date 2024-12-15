import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rewardly/Application%20Layer/bloc/signup/sign_up_bloc.dart';
import 'package:rewardly/Application%20Layer/bloc/signup/sign_up_event.dart';
import 'package:rewardly/Application%20Layer/bloc/signup/sign_up_state.dart';
import 'package:uuid/uuid.dart';

import '../../../Data/models/user.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key, required this.users});

  final Users users;
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController pseudoController = TextEditingController();


   final Uuid id = const Uuid();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    pseudoController.dispose();
    super.dispose();
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer un compte'),
      ),
      body: BlocConsumer<SignUpBloc, SignUpState>(
        listener: (context, state) {
          if (state is SignUpSuccess) {
            Navigator.pushNamed(context, '/home');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Connexion réussie, bienvenue ${pseudoController.text} !'),
              ),
            );
          } else if (state is SignUpFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
              ),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: pseudoController,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Pseudo',
                      border: OutlineInputBorder(),
                      helperText: 'Entrez votre pseudo.',
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Adresse e-mail',
                      border: OutlineInputBorder(),
                      helperText: 'Entrez une adresse e-mail valide.',
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Mot de passe',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: 'Confirmer le mot de passe',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 24.0),
                  if (state is SignUpLoading)
                    CircularProgressIndicator()
                  else
                    ElevatedButton(
                      onPressed: () {
                        _dismissKeyboard();

                        if (pseudoController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Veuillez entrer un pseudo.")),
                          );
                          return;
                        }

                        if (!_isValidEmail(emailController.text)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Veuillez entrer une adresse e-mail valide.")),
                          );
                          return;
                        }

                        if (passwordController.text != confirmPasswordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Les mots de passe ne correspondent pas.")),
                          );
                          return;
                        }

                        context.read<SignUpBloc>().add(
                          SignUpRequested(
                            users : Users(
                              pseudo: pseudoController.text,
                              mail: emailController.text,
                              password: passwordController.text,
                              id: id.v1(),
                            ),
                          ),
                        );
                      },
                      child: Text('Créer un compte'),
                    ),
                ],
              ),
          );
        },
      ),
    );
  }
}
