import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String id;
  final String parentId;
  final String name;
  final String description;
  final DateTime? deadline;
  final int priority;
  final bool isDone;
  final DocumentReference<Object?>? projectRef;

  TaskModel({
    required this.id,
    required this.parentId,
    required this.name,
    this.description = "",
    this.deadline,
    this.priority = 0,
    this.isDone = false,
    required this.projectRef,
  });

  factory TaskModel.fromMap(Map<String, dynamic> data) {
    return TaskModel(
      id: data['task_id'],
      parentId: data['parent_id'],
      name: data['name'],
      description: data['description'],
      deadline: data['deadline'] is Timestamp
          ? (data['deadline'] as Timestamp).toDate()
          : DateTime.tryParse(data['deadline'] ?? ''),
      priority: data['priority'],
      isDone: data['isDone'],
      projectRef: data['projectRef'] as DocumentReference<Object?>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'task_id': id,
      'parent_id': parentId,
      'name': name,
      'description': description,
      'deadline': deadline != null ? Timestamp.fromDate(deadline!) : null,
      'priority': priority,
      'isDone': isDone,
      'project_ref': projectRef,
    };
  }
}
