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
}