import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../Data/models/friendly_entity.dart';
import '../models/user_entity.dart';

class FirestoreFriendlyService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addFriend(Friendly friend) async {
    friend.user_id = _firebaseAuth.currentUser!.uid;
    await _firestore.collection('friendly').add(friend.toMap());
  }


  Future<List<Users>> getUser() async {
    final crrntUser = _firebaseAuth.currentUser!.uid;
    final QuerySnapshot friendSnapshot = await _firestore
        .collection('friendly')
        .where('user_id', isEqualTo: crrntUser)
        .get();

    List<Users> friends = [];
    for (var doc in friendSnapshot.docs) {
      final friendData = doc.data() as Map<String, dynamic>;
      final userId = friendData['friend_id'];
      final userDoc = await _firestore.collection('users').where('user_id', isEqualTo: userId).get();
      for (var user in userDoc.docs) {
        final userData = user.data();
        final friend = Users.fromMap(userData);
        friends.add(friend);
      }
    }
    return friends;
  }

  Future<void> removeFriend(Friendly friendly) async {
    final QuerySnapshot friendSnapshot = await _firestore
        .collection('friendly')
        .where('user_id', isEqualTo: _firebaseAuth.currentUser!.uid)
        .where('friend_id', isEqualTo: friendly.friend_id)
        .get();
  }

  Future<List<Users>> searchInFriend(String pseudo) async {
    List<Users> friends = await getUser();
    return friends.where((element) => element.pseudo.contains(pseudo)).toList();
  }


}