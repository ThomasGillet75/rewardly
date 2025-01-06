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
    await _firestore
        .collection('tasks')
        .where('parent_id', isEqualTo: id)
        .get()
        .then((value) {
      for (var element in value.docs) {
        element.reference.delete();
      }
    });
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
    final querySnapshot = _firestore
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
    return querySnapshot.docs
        .map((doc) => TaskModel.fromMap(doc.data()))
        .toList();
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

  Future<List<String>> _getUserProjectIds(String userId) async {
    print('\x1B[32mUser ID: $userId\x1B[0m'); // Green

    final snapshot = await FirebaseFirestore.instance
        .collection('project_members')
        .where('user_id', isEqualTo: userId)
        .get();

    final projectIds =
    snapshot.docs.map((doc) => doc.data()['project_id'] as String).toList();

    for (var projectId in projectIds) {
      print('\x1B[34mProject ID: $projectId\x1B[0m'); // Blue
    }

    return projectIds;
  }

  Stream<List<TaskModel>> getTasksByUserProjects(String userId) async* {
    final projectIds = await _getUserProjectIds(userId);

    if (projectIds.isEmpty) {
      print('\x1B[31mNo projects found for user ID: $userId\x1B[0m'); // Red
      yield [];
    } else {
      final trimmedProjectIds = projectIds.map((id) => id.trim()).toList();
      yield* FirebaseFirestore.instance
          .collection('tasks')
          .where('project_id', whereIn: trimmedProjectIds)
          .snapshots()
          .map((snapshot) {
        final tasks = snapshot.docs.map((doc) {
          return TaskModel.fromMap(doc.data());
        }).toList();

        if (tasks.isEmpty) {
          print('\x1B[31mNo tasks found for user ID: $userId\x1B[0m'); // Red
        } else {
          for (var task in tasks) {
            print('\x1B[34mTask ID: ${task.id}\x1B[0m'); // Blue
            print('\x1B[32mTask Name: ${task.name}\x1B[0m'); // Green
          }
        }

        return tasks;
      });
    }
  }
}