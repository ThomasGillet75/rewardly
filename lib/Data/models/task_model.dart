class TaskModel {
  final String id;
  final String parentId;
  final String name;
  final String description;
  final String deadline;
  final int priority;
  final String projectId;

  TaskModel({
    required this.id,
    required this.parentId,
    required this.name,
    this.description = "",
    this.deadline = "",
    this.priority = 0,
    required this.projectId,
  });

  factory TaskModel.fromMap(Map<String, dynamic> data) {
    return TaskModel(
      id: data['task_id'],
      parentId: data['parent_id'],
      name: data['name'],
      description: data['description'],
      deadline: data['deadline'],
      priority: data['priority'],
      projectId: data['project_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'task_id': id,
      'parent_id': parentId,
      'name': name,
      'description': description,
      'deadline': deadline,
      'priority': priority,
      'project_id': projectId,
    };
  }
}