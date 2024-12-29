import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../Data/models/friendly_entity.dart';
import '../models/user_entity.dart';

class FirestoreFriendlyService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addFriend(Friendly friend) async {
    friend.userId = _firebaseAuth.currentUser!.uid;
    await _firestore.collection('friendly').add(friend.toMap());
  }


  Future<List<Users>> getUser() async {
    final QuerySnapshot userSnapshot = await _firestore.collection('users').get();
    final QuerySnapshot friendSnapshot = await _firestore.collection('friendly').where('user_id', isEqualTo: _firebaseAuth.currentUser!.uid).get();

    List<Users> users = userSnapshot.docs.map((doc) => Users.fromMap(doc.data() as Map<String,dynamic>)).toList();
    List<Friendly> friends = friendSnapshot.docs.map((doc) => Friendly.fromMap(doc.data() as Map<String,dynamic>)).toList();

    return users.where((element) => friends.any((friend) => friend.friendId == element.id)).toList();
  }

  Future<void> removeFriend(Friendly friendly) async {
    await _firestore.collection('friendly').where('user_id', isEqualTo: _firebaseAuth.currentUser!.uid).where('friend_id', isEqualTo: friendly.friendId).get().then((value) {
      value.docs.forEach((element) {
        _firestore.collection('friendly').doc(element.id).delete();
      });
    });
  }

  Future<List<Users>> searchInFriend(String pseudo) async {
    List<Users> friends = await getUser();
    return friends.where((element) => element.pseudo.contains(pseudo)).toList();
  }


}