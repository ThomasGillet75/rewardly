import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../Data/services/firestore_user_service.dart';

class SignInViewModel {
  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  VoidCallback signIn(BuildContext context) {
    return () async {
      isLoading.value = true;

      try {
        final email = emailController.text.trim();
        final password = passwordController.text.trim();

        if (email.isEmpty || password.isEmpty) {
          throw Exception('Veuillez remplir tous les champs.');
        }

        UserCredential credential = await _authService.signInWithEmail(email, password);

        // Connexion réussie
        Navigator.pushNamed(context, '/home');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connexion réussie, bienvenue ${credential.user?.displayName ?? 'Utilisateur'} !')),
        );
      } catch (e) {
        // Gestion des erreurs
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      } finally {
        isLoading.value = false;
      }
    };
  }
}
