import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rewardly/Data/models/user.dart';
import 'package:uuid/uuid.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
        throw Exception('Pseudo already in use');
      }

      // Create the user if the pseudo does not exist
      final credential = await _auth.createUserWithEmailAndPassword(email: user.mail, password: user.password);
      await credential.user!.updateDisplayName(user.pseudo);

      await _firestore.collection('users').doc(credential.user!.uid).set(user.toMap());

      return credential;
    } catch (e) {
      throw Exception('Erreur d\'inscription : ${e.toString()}');
    }
  }

  Future<List<Users>> searchUsers(String pseudo) async {
    final querySnapshot = await _firestore.collection('users').get();

    // Filter results manually to find substrings
    return querySnapshot.docs
        .map((doc) => Users.fromMap(doc.data()))
        .where((user) => user.pseudo.contains(pseudo))
        .toList();
  }


}