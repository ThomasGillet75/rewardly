import 'package:rewardly/Core/task_priority_enum.dart';
import 'package:rewardly/Data/models/sub_task_entity.dart';
import 'package:rewardly/Data/models/task_entity.dart';
import 'package:rewardly/Data/models/task_model.dart';
import 'package:rewardly/Data/services/firestore_task_service.dart';

class TaskRepository {
  final FirestoreTaskService _taskService = FirestoreTaskService();

  Future<List<Task>> getTasksByUserId(String userRef) async {
    final taskModels = await _taskService.getByUserId(userRef);
    return taskModels.map((taskModel) => taskModelToTask(taskModel)).toList();
  }

  Future<void> createTask(Task task) async {
    await _taskService.addInDb(taskToTaskModel(task));
  }

  Future<Task> getTask(String taskId) async {
    final taskModels = await _taskService.get(taskId);
    return taskModelToTask(taskModels);
  }

  //sorting tasks and subtasks
  //taskModels: list of taskModels to sort
  Future<List<Task>> _sortingTasksSubTask(List<TaskModel> taskModels) async {
    final tasksWithoutParent =
        taskModels.where((taskModel) => taskModel.parentId.isEmpty).toList();
    final tasks = await Future.wait(tasksWithoutParent.map((taskModel) async {
      final task = taskModelToTask(taskModel);
      final subTaskModels =
          await _taskService.getTasksByParentId(task.id).first;
      task.subTasks = subTaskModels.map(taskModelToSubTask).toList();
      return task;
    }).toList());

    return tasks;
  }

  Stream<List<Task>> getTasksByProjectId(String projectId) {
    return _taskService
        .getTasksByProjectId(projectId)
        .asyncMap((taskModels) => _sortingTasksSubTask(taskModels));
  }

  Stream<List<Task>> getTasks() {
    return _taskService
        .getAll()
        .asyncMap((taskModels) => _sortingTasksSubTask(taskModels));
  }

  Stream<List<Task>> getTaskAndSubTask() {
    return _taskService.getAll().map((taskModels) {
      return taskModels.map((taskModel) => taskModelToTask(taskModel)).toList();
    });
  }

  void addSubTask(SubTask task) {
    TaskModel taskModel = taskToTaskModel(task);
    _taskService.add(taskModel);
  }

  void updateSubTask(SubTask task) {
    TaskModel taskModel = taskToTaskModel(task);
    _taskService.update(taskModel);
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
      projectId: taskModel.projectId,
      subTasks: [],
    );
  }

  SubTask taskModelToSubTask(TaskModel taskModel) {
    return SubTask(
      name: taskModel.name,
      priority: TaskPriority.values[taskModel.priority],
      deadline: taskModel.deadline ?? DateTime.now(),
      isDone: taskModel.isDone,
      projectId: taskModel.projectId,
      id: taskModel.id,
      parentId: taskModel.parentId,
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

  void removeSubTask(SubTask task) {
    _taskService.delete(task.id);
  }
}
