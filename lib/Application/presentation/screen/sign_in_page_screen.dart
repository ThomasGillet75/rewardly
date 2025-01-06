import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rewardly/Application/bloc/signin/sign_in_bloc.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connexion'),
      ),
      body: BlocConsumer<SignInBloc, SignInState>(
        listener: (context, state) {
          if (state is SignInSuccess) {
            Navigator.pushNamed(context, '/home');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Connexion réussie, bienvenue ${emailController.text} !'),
              ),
            );
          } else if (state is SignInFailure) {
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
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Adresse e-mail',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 24.0),
                if (state is SignInLoading)
                  CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: () {
                      context.read<SignInBloc>().add(
                            SignInRequested(
                              email: emailController.text,
                              password: passwordController.text,
                            ),
                          );
                    },
                    child: Text('Se connecter'),
                  ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signUp');
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
