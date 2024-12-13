

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rewardly/core/task_priority_enum.dart';

class Task {
  String id;
  String parentId;
  String name;
  TaskPriority priority;
  DateTime? deadline;
  int numberSubtask; //surement devoir Changer en list de subtask
  String description;
  bool isDone;
  DocumentReference<Object?>? projectRef;

  Task(
      {required this.name,
      required this.priority,
      required this.deadline,
      required this.numberSubtask,
      required this.isDone,
      this.description = "",
      this.id = "",
      this.parentId = "",
      required this.projectRef});


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
    String? description,
    String? parentId,
    String? id,
    DocumentReference<Object?>? projectRef,
  }) {
    return Task(
      name: name ?? this.name,
      priority: priority ?? this.priority,
      deadline: deadline ?? this.deadline,
      numberSubtask: numberSubtask ?? this.numberSubtask,
      isDone: isDone ?? this.isDone,
      description: description ?? this.description,
      parentId: parentId ?? this.parentId,
      id: id ?? this.id,
      projectRef: projectRef ?? this.projectRef,
    );
  }
}
