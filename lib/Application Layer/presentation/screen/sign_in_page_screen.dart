import 'package:flutter/material.dart';
import '../viewmodel/sign_in_page_view_model.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final SignInViewModel _viewModel = SignInViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connexion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          TextField(
          controller: _viewModel.emailController,
          keyboardType: TextInputType.emailAddress, decoration: InputDecoration(
    labelText: 'Adresse e-mail',
    border: OutlineInputBorder(),
    ),
    ),
    SizedBox(height: 16.0),
    TextField(
    controller: _viewModel.passwordController,
    obscureText: true,
    decoration: InputDecoration(
    labelText: 'Mot de passe',
    border: OutlineInputBorder(),
    ),
    ),
    SizedBox(height: 24.0),
    ValueListenableBuilder<bool>(
    valueListenable: _viewModel.isLoading,
    builder: (context, isLoading, _) {
    return isLoading
    ? CircularProgressIndicator()
        : ElevatedButton(
    onPressed: _viewModel.signIn(context),
    child: Text('Se connecter'),

    );
    },
    ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/sign-up');
            },
            child: Text('Créer un compte'),
          ),
          ],
        ),
      ),
    );
  }
}