import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rewardly/Data/models/project_members_entity.dart';
import 'package:rewardly/Data/models/user_entity.dart';

import 'firestore_project_members_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ProjectMembersService _projectMembersService = ProjectMembersService();

  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      throw Exception('Erreur de connexion : ${e.toString()}');
    }
  }

  Future<UserCredential> signUpWithEmail(Users user) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('pseudo', isEqualTo: user.pseudo)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        throw Exception('Pseudo déjà utilisé');
      }
      final credential = await _auth.createUserWithEmailAndPassword(
          email: user.mail, password: user.password);
      user.id = _auth.currentUser!.uid;
      await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .set(user.toMap());

      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('Le mot de passe est trop faible.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('Cet email est déjà utilisé.');
      } else {
        throw Exception('Erreur d\'inscription : ${e.toString()}');
      }
    } catch (e) {
      throw Exception('Erreur d\'inscription : ${e.toString()}');
    }
  }

  Future<List<Users>> searchUsers(String pseudo) async {
    final querySnapshot = await _firestore.collection('users').get();
    final friendlyQuerySnapshot = await _firestore
        .collection('friendly')
        .where('user_id', isEqualTo: _auth.currentUser!.uid)
        .get();

    final friendIds = friendlyQuerySnapshot.docs
        .map((doc) => doc['friend_id'] as String)
        .toSet();
    return querySnapshot.docs
        .map((doc) => Users.fromMap(doc.data()))
        .where((user) =>
            user.pseudo.contains(pseudo) &&
            user.id != _auth.currentUser!.uid &&
            !friendIds.contains(user.id))
        .toList();
  }

  Future<Map<String, List<Users>>> getUsersByProject() async {
    final projectMembers = await _projectMembersService.getAll().first;
    final Map<String, List<ProjectMembersEntity>> membersByProject = {};
    for (var member in projectMembers) {
      if (!membersByProject.containsKey(member.projectId)) {
        membersByProject[member.projectId] = [];
      }
      membersByProject[member.projectId]!.add(member);
    }
    final Map<String, List<Users>> usersByProject = {};
    for (var entry in membersByProject.entries) {
      final projectId = entry.key;
      final userIds = entry.value.map((member) => member.userId).toList();
      if (userIds.isEmpty) {
        usersByProject[projectId] = [];
        continue;
      }
      final querySnapshot = await _firestore
          .collection('users')
          .where('user_id', whereIn: userIds)
          .get();
      final users =
          querySnapshot.docs.map((doc) => Users.fromMap(doc.data())).toList();

      usersByProject[projectId] = users;
    }

    return usersByProject;
  }

  Future<List<Users>> getUsersNotInProject(String projectId) async {
    final projectMembers = await _projectMembersService.getAll().first;

    final userIdsInProject = projectMembers
        .where((member) => member.projectId == projectId)
        .map((member) => member.userId)
        .toSet();

    final usersIsFriendly = await _firestore
        .collection('friendly')
        .where('user_id', isEqualTo: _auth.currentUser!.uid)
        .get();

    final usersIsFriendlyIds =
        usersIsFriendly.docs.map((doc) => doc['friend_id'] as String).toSet();

    final querySnapshot = await _firestore.collection('users').get();

    final allUsers =
        querySnapshot.docs.map((doc) => Users.fromMap(doc.data())).toList();

    final usersNotInProject = allUsers.where((user) {
      final isNotInProject = !userIdsInProject.contains(user.id);
      final isFriend = usersIsFriendlyIds.contains(user.id);
      return isNotInProject && isFriend;
    }).toList();

    return usersNotInProject;
  }

  Future<List<Users>> searchUsersNotInProject(String pseudo) {
    return getUsersNotInProject(_auth.currentUser!.uid).then((users) {
      return users.where((user) => user.pseudo.contains(pseudo)).toList();
    });
  }
}
