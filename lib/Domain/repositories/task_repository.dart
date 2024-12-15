import 'package:rewardly/Data/models/sub_task_entity.dart';
import 'package:rewardly/Data/models/task_entity.dart';
import 'package:rewardly/Data/models/task_model.dart';
import 'package:rewardly/Data/services/firestore_task_service.dart';
import 'package:rewardly/Core/task_priority_enum.dart';

class TaskRepository {
  final FirestoreTaskService _taskService = FirestoreTaskService();

  Future<List<Task>> getTasksByUserId(String userRef) async {
    final taskModels = await _taskService.getByUserId(userRef);
    return taskModels
        .map((taskModel) => taskModelToTask(taskModel))
        .toList();
  }

  Future<void> createTask(TaskModel taskModel) async {
    await _taskService.add(taskModel);
  }

  Future<Task> getTask(String taskId) async {
    final taskModels = await _taskService.get(taskId);
    return taskModelToTask(taskModels);
  }

  Stream<List<Task>> getTasksByProjectId(String projectId) {
    return _taskService.getTasksByProjectId(projectId).map((taskModels) {
      return taskModels.map((taskModel) => taskModelToTask(taskModel)).toList();
    });
  }

  Stream<List<Task>> getTasks() {
    return _taskService.getAll().map((taskModels) {
      return taskModels.map((taskModel) => taskModelToTask(taskModel)).toList();
    });
  }

  Future<void> updateTask(Task task) async {
    await _taskService.update(taskToTaskModel(task));
  }

  Future<void> deleteTask(String taskId) async {
    await _taskService.delete(taskId);
  }


  // Convert TaskModel to Task
  Task taskModelToTask(TaskModel taskModel) {
    return Task(
      name: taskModel.name,
      priority: TaskPriority.values[taskModel.priority],
      deadline: taskModel.deadline ?? DateTime.now(),
      isDone: taskModel.isDone,
      description: taskModel.description,
      id: taskModel.id,
      projectId: taskModel.projectId, subTasks: [],
    );
  }

  TaskModel taskToTaskModel(Task task) {
    return TaskModel(
      id: task.id,
      name: task.name,
      description: task.description,
      deadline: task.deadline,
      priority: task.priority.index,
      isDone: task.isDone,
      projectId: task.projectId,
      parentId: task.parentId,
    );
  }

  void addSubTask(SubTask task) {
    TaskModel taskModel = taskToTaskModel(task);
    _taskService.add(taskModel);
  }
}
