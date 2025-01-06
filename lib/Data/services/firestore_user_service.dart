import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rewardly/Data/models/user_entity.dart';

import '../models/project_members_entity.dart';
import 'firestore_project_members_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ProjectMembersService _projectMembersService = ProjectMembersService();

  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw Exception('Erreur de connexion : ${e.toString()}');
    }
  }


  Future<UserCredential> signUpWithEmail(Users user) async {
    try {
      // Check if the pseudo already exists
      final querySnapshot = await _firestore.collection('users')
          .where('pseudo', isEqualTo: user.pseudo)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        throw Exception('Pseudo déjà utilisé');
      }


      // Create the user if the pseudo does not exist
      final credential = await _auth.createUserWithEmailAndPassword(
          email: user.mail, password: user.password);

      // user id is the same as the user id in firebase
      user.id = _auth.currentUser!.uid;

      // Store user data in Firestore
      await _firestore.collection('users').doc(credential.user!.uid).set(user.toMap());

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
    final friendlyQuerySnapshot = await _firestore.collection('friendly')
        .where('user_id', isEqualTo: _auth.currentUser!.uid)
        .get();

    final friendIds = friendlyQuerySnapshot.docs
        .map((doc) => doc['friend_id'] as String)
        .toSet();

    // Filter results manually to find substrings and exclude friends
    return querySnapshot.docs
        .map((doc) => Users.fromMap(doc.data()))
        .where((user) => user.pseudo.contains(pseudo) && user.id != _auth.currentUser!.uid && !friendIds.contains(user.id))
        .toList();
  }

  Future<Map<String, List<Users>>> getUsersByProject() async {
    // Fetch project members
    final projectMembers = await _projectMembersService.getAll().first;

    // Group project members by project ID
    final Map<String, List<ProjectMembersEntity>> membersByProject = {};
    for (var member in projectMembers) {
      if (!membersByProject.containsKey(member.projectId)) {
        membersByProject[member.projectId] = [];
      }
      membersByProject[member.projectId]!.add(member);
    }

    // Prepare a map to hold users by project ID
    final Map<String, List<Users>> usersByProject = {};

    // Iterate over each project and fetch users
    for (var entry in membersByProject.entries) {
      final projectId = entry.key;
      final userIds = entry.value.map((member) => member.userId).toList();

      // Handle empty user IDs
      if (userIds.isEmpty) {
        usersByProject[projectId] = [];
        continue;
      }

      // Query the users collection using the user IDs
      final querySnapshot = await _firestore
          .collection('users')
          .where('user_id', whereIn: userIds)
          .get();

      // Map the snapshot to a list of Users
      final users = querySnapshot.docs.map((doc) => Users.fromMap(doc.data())).toList();

      // Add the users to the map under the correct projectId
      usersByProject[projectId] = users;
    }

    // Return the map of users grouped by project ID
    return usersByProject;
  }
//get user not in project
  Future<List<Users>> getUsersNotInProject(String projectId) async {
    // Fetch project members
    final projectMembers = await _projectMembersService.getAll().first;

    // Extract all user IDs associated with the given projectId
    final userIdsInProject = projectMembers
        .where((member) => member.projectId == projectId)
        .map((member) => member.userId)
        .toSet();

    // Fetch the user's friends
    final usersIsFriendly = await _firestore
        .collection('friendly')
        .where('user_id', isEqualTo: _auth.currentUser!.uid)
        .get();

    // Extract friend IDs
    final usersIsFriendlyIds = usersIsFriendly.docs
        .map((doc) => doc['friend_id'] as String)
        .toSet();

    // Query the users collection for all users
    final querySnapshot = await _firestore.collection('users').get();

    // Map the snapshot to a list of Users
    final allUsers = querySnapshot.docs
        .map((doc) => Users.fromMap(doc.data()))
        .toList();

    // Filter out users who are part of the specified project or are not friends
    final usersNotInProject = allUsers.where((user) {
      final isNotInProject = !userIdsInProject.contains(user.id);
      final isFriend = usersIsFriendlyIds.contains(user.id);
      return isNotInProject && isFriend;
    }).toList();

    return usersNotInProject;
  }

  Future<List<Users>> searchUsersNotInProject(String pseudo) {
    // Fetch all users not in the project
    return getUsersNotInProject(_auth.currentUser!.uid).then((users) {
      // Filter the users by pseudo
      return users.where((user) => user.pseudo.contains(pseudo)).toList();
    });
  }








}