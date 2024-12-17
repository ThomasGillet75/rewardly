import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rewardly/Data/models/user_entity.dart';

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
        throw Exception('Pseudo déjà utilisé');
      }


      // Create the user if the pseudo does not exist
      final credential = await _auth.createUserWithEmailAndPassword(
          email: user.mail, password: user.password);

      // user id is the same as the user id in firebase
      user.id = _auth.currentUser!.uid;

      // Send email verification
      await _auth.currentUser!.sendEmailVerification();

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
    final friendlyQuerySnapshot = await _firestore.collection('friendly').get();
    // Filter results manually to find substrings
    return querySnapshot.docs
        .map((doc) => Users.fromMap(doc.data()))
        .where((user) => user.pseudo.contains(pseudo) && user.id != _auth.currentUser!.uid && friendlyQuerySnapshot.docs.every((doc) => doc['friend_id'] != user.id))
        .toList();
  }


}