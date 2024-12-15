import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rewardly/Data/models/task_model.dart';
import 'package:rewardly/Data/services/firestore_data_service.dart';
import 'package:uuid/uuid.dart';

class FirestoreTaskService extends IDataService<TaskModel> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

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

  Stream<List<TaskModel>> getTasksByProjectId(String projectRef) {
    final querySnapshot =  _firestore
        .collection('tasks')
        .where('project_id', isEqualTo: projectRef)
        .snapshots();
    return querySnapshot.map((snapshot) {
      return snapshot.docs.map((doc) => TaskModel.fromMap(doc.data())).toList();
    });
  }

  Future<List<TaskModel>> getByUserId(String userRef) async {
    final querySnapshot = await _firestore
        .collection('tasks')
        .where('user_id', isEqualTo: userRef)
        .get();
    return querySnapshot.docs.map((doc) => TaskModel.fromMap(doc.data())).toList();
  }

  Stream<List<TaskModel>> getTasksByParentId(String id) {
    final querySnapshot = _firestore
        .collection('tasks')
        .where('parent_id', isEqualTo: id)
        .snapshots();
    return querySnapshot.map((snapshot) {
      return snapshot.docs.map((doc) => TaskModel.fromMap(doc.data())).toList();
    });
  }
}
