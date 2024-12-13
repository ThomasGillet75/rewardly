import 'package:flutter/material.dart';
import '../../../Domain/repositories/user_repository.dart';

class SignUpPageViewModel {
  final UserRepository _authService = UserRepository();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  VoidCallback signUp(BuildContext context) {
    return () async {
      isLoading.value = true;

      try {
        final email = emailController.text.trim();
        final password = passwordController.text.trim();
        final confirmPassword = confirmPasswordController.text.trim();

        if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
          throw Exception('Veuillez remplir tous les champs.');
        }else if(password != confirmPassword){
          throw Exception('Les mots de passe ne correspondent pas.');
        }
         final credential = await _authService.signUpWithEmail(email, password);

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