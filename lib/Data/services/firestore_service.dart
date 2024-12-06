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

  Future<List<QueryDocumentSnapshot>> getTasksByProjectId(
      String projectId) async {
    final querySnapshot = await _firestore
        .collection('tasks')
        .where('project_id', isEqualTo: projectId)
        .get();
    return querySnapshot.docs;
  }

  Future<void> createTask(Map<String, dynamic> taskModel) {
    return _firestore
        .collection('projects')
        .doc(taskModel['project_id'])
        .collection('tasks')
        .add(taskModel);
  }

  Future<List<QueryDocumentSnapshot>> getProjects() async {
    final querySnapshot = await _firestore.collection('projects').get();
    return querySnapshot.docs;
  }
}
