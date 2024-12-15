import 'package:flutter/material.dart';
import 'package:rewardly/Application/presentation/viewmodel/sign_up_page_view_model.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final SignUpPageViewModel _viewModel = SignUpPageViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer un compte'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _viewModel.emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
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
            TextField(
              controller: _viewModel.confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirmer le mot de passe',
                border: OutlineInputBorder(),
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: _viewModel.isLoading,
              builder: (context, isLoading, _) {
                return isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _viewModel.signUp(context),
                  child: Text('Créer un compte'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}