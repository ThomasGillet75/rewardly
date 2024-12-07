import 'package:rewardly/Data/models/task_model.dart';
import 'package:rewardly/Data/services/firestore_task_service.dart';


class TaskRepository {
  final FirestoreTaskService _taskService = FirestoreTaskService();

  Future<List<TaskModel>> getTasksByUserRef(String userId) async {
    final taskDocs = await _taskService.getByUserRef(userId);
    return taskDocs.map((doc) => TaskModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> createTask(TaskModel taskModel) async {
    await _taskService.add(taskModel);
  }

  Future<TaskModel> getTask(String taskId) async {
    final taskDoc = await _taskService.get(taskId);
    return TaskModel.fromMap(taskDoc as Map<String, dynamic>);
  }

  Future<void> updateTask(TaskModel taskModel) async {
    await _taskService.update(taskModel);
  }

  Future<void> deleteTask(String taskId) async {
    await _taskService.delete(taskId);
  }
}
