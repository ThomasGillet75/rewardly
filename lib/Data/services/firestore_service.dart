import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<QueryDocumentSnapshot>> getTasksByUserId(String userId) async {
    final querySnapshot = await _firestore
        .collection('tasks')
        .where('user_id', isEqualTo: userId)
        .get();
    return querySnapshot.docs;
  }
}
