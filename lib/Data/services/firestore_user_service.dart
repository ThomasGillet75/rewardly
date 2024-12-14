import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future<UserCredential> signUpWithEmail(String email, String password, String name) async {
    try {
      // Check if the pseudo already exists
      final querySnapshot = await _firestore.collection('users')
          .where('user_name', isEqualTo: name)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        throw Exception('Pseudo already in use');
      }

      // Create the user if the pseudo does not exist
      final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await credential.user!.updateDisplayName(name);

      await _firestore.collection('users').doc(credential.user!.uid).set({
        'user_id': credential.user!.uid,
        'mail_address': email,
        'user_name': name,
      });

      return credential;
    } catch (e) {
      throw Exception('Erreur d\'inscription : ${e.toString()}');
    }
  }
}