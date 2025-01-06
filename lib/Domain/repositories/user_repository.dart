import 'package:firebase_auth/firebase_auth.dart';
import 'package:rewardly/Data/models/user_entity.dart';
import 'package:rewardly/Data/services/firestore_user_service.dart';

class UserRepository {
  final AuthService _userService = AuthService();

  Future<UserCredential> signInWithEmail(String email, String password) async {
    return await _userService.signInWithEmail(email, password);
  }

  Future<UserCredential> signUpWithEmail(Users user ) async {
    return await _userService.signUpWithEmail(user);
  }

  Future<List<Users>>getUser(String pseudo) async {

    return await _userService.searchUsers(pseudo);
  }

  Future<Map<String, List<Users>>>getUsers() async  {

    return await  _userService.getUsersByProject();
  }


  Future<List<Users>>getUsersNotInProject(String projectId) async  {

    return await  _userService.getUsersNotInProject(projectId);
  }

  Future<List<Users>>searchUsersNotInProject(String pseudo) {
    return _userService.searchUsersNotInProject(pseudo);
  }



}

