

import 'package:rewardly/Data/models/task_model.dart';
import 'package:rewardly/Data/services/firestore_service.dart';

class TaskRepository
{
  final FirestoreService _firestoreService = FirestoreService();

  Future<List<TaskModel>> getTasksByUserId(String userId) async {
    final taskDocs = await _firestoreService.getTasksByUserId(userId);

    return taskDocs.map((doc) => TaskModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }
}