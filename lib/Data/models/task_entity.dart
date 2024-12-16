import 'package:rewardly/Core/task_priority_enum.dart';
import 'package:rewardly/Data/models/sub_task_entity.dart';

class Task {
  String id;
  String parentId;
  String name;
  TaskPriority priority;
  DateTime? deadline;
  List<SubTask> subTasks;
  String description;
  bool isDone;
  String projectId;

  Task({
    required this.name,
    required this.priority,
    required this.deadline,
    required this.subTasks,
    required this.isDone,
    this.description = "",
    this.id = "",
    this.parentId = "",
    required this.projectId,
  });

  // Toggle the task done or not
  void toggleDone() {
    isDone = !isDone;
  }

  String calculateTotalSubTaskToDo() {
    return subTasks.length.toString();
  }

  String calculateLeftSubTaskToDo() {
    return subTasks.where((element) => element.isDone).length.toString();
  }

  bool isAllSubTaskDone() {
    return subTasks.every((element) => element.isDone);
  }

  Task copyWith({
    String? name,
    TaskPriority? priority,
    DateTime? deadline,
    List<SubTask>? subTasks,
    bool? isDone,
    String? description,
    String? parentId,
    String? id,
    String? projectId,
  }) {
    return Task(
      name: name ?? this.name,
      priority: priority ?? this.priority,
      deadline: deadline ?? this.deadline,
      subTasks: subTasks ?? this.subTasks,
      isDone: isDone ?? this.isDone,
      description: description ?? this.description,
      parentId: parentId ?? this.parentId,
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
    );
  }
}
