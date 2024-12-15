import 'package:rewardly/Core/task_priority_enum.dart';
import 'package:rewardly/Data/models/task_entity.dart';

class SubTask extends Task {
  SubTask({
    required super.name,
    required super.priority,
    required DateTime super.deadline,
    required super.isDone,
    super.description,
    super.id,
    super.parentId,
    required super.projectId,
  }) : super(
          subTasks: [],
        );

  @override
  void toggleDone() {
    isDone = !isDone;
  }

  SubTask copyingWith({
    String? name,
    TaskPriority? priority,
    DateTime? deadline,
    bool? isDone,
    String? description,
    String? id,
    String? parentId,
    String? projectId,
  }) {
    return SubTask(
      name: name ?? this.name,
      priority: priority ?? this.priority,
      deadline: deadline ?? this.deadline!,
      isDone: isDone ?? this.isDone,
      description: description ?? this.description,
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      projectId: projectId ?? this.projectId,
    );
  }
}