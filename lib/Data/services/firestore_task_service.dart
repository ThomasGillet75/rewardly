import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rewardly/Data/models/task_model.dart';
import 'package:rewardly/Data/services/firestore_data_service.dart';
import 'package:uuid/uuid.dart';

class FirestoreTaskService extends IDataService<TaskModel> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = Uuid();

  @override
  Future<void> add(TaskModel item) async {
    String taskId = _uuid.v4();
    await _firestore.collection('tasks').doc(taskId).set({
      ...item.toMap(),
      'task_id': taskId,
    });
  }

  @override
  Future<void> delete(String id) async {
    await _firestore.collection('tasks').doc(id).delete();
  }

  @override
  Future<TaskModel> get(String id) async {
    var doc = await _firestore.collection('tasks').doc(id).get();
    return TaskModel.fromMap(doc.data()!);
  }

  @override
  Stream<List<TaskModel>> getAll() {
    final querySnapshot = _firestore.collection('tasks').snapshots();
    return querySnapshot.map((snapshot) {
      return snapshot.docs.map((doc) => TaskModel.fromMap(doc.data())).toList();
    });
  }

  @override
  Future<void> update(TaskModel item) async {
    await _firestore.collection('tasks').doc(item.id).update(item.toMap());
  }

  Future<List<QueryDocumentSnapshot>> getTasksByProjectRef(
      DocumentReference projectRef) async {
    final querySnapshot = await _firestore
        .collection('tasks')
        .where('project_ref', isEqualTo: projectRef)
        .get();
    return querySnapshot.docs;
  }

  Future<List<QueryDocumentSnapshot>> getByUserRef(String userRef) {
    final querySnapshot = _firestore
        .collection('tasks')
        .where('user_ref', isEqualTo: userRef)
        .get();
    return querySnapshot.then((value) => value.docs);
  }
}
