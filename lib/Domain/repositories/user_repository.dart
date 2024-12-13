import 'package:firebase_auth/firebase_auth.dart';

import '../../Data/services/firestore_user_service.dart';

class UserRepository {
  final AuthService _userService = AuthService();

  Future<UserCredential> signInWithEmail(String email, String password) async {
    return await _userService.signInWithEmail(email, password);
  }

  Future<UserCredential> signUpWithEmail(String email, String password) async {
    return await _userService.signUpWithEmail(email, password);
  }

}