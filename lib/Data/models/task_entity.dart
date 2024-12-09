

import 'package:rewardly/core/task_priority_enum.dart';

class Task {
  String id;
  String ParentId;
  String name;
  TaskPriority priority;
  DateTime deadline;
  int numberSubtask; //surement devoir Changer ca
  String description;
  bool isDone;
  String DocumentRef;

  Task(
      {required this.name,
      required this.priority,
      required this.deadline,
      required this.numberSubtask,
      required this.isDone,
      this.description = "",
      this.id = "",
      this.ParentId = "",
      this.DocumentRef = ""});


  //toggle the task done or not
  void toggleDone() {
    isDone = !isDone;
  }

  Task copyWith({
    String? name,
    TaskPriority? priority,
    DateTime? deadline,
    int? numberSubtask,
    bool? isDone,
  }) {
    return Task(
      name: name ?? this.name,
      priority: priority ?? this.priority,
      deadline: deadline ?? this.deadline,
      numberSubtask: numberSubtask ?? this.numberSubtask,
      isDone: isDone ?? this.isDone,
    );
  }
}
