
class TaskModel {
  late final int id;
  late final int parentId;
  late final String name;
  late final String description;
  late final String deadline;
  late final int priority;
  late final int projectId;

  TaskModel({required int id,
    required int parentId,
    required String name,
    String description = "",
    String deadline = "",
    int priority = 0,
    required int projectId,});

  factory TaskModel.fromMap(Map<String, dynamic> data){
    return TaskModel(id: data['id'], parentId: data['parent_id'],deadline: data['deadline'],description:data['description'],priority: data['priority'], name: data['name'], projectId: data['project_id']);
  }

  Map<String,dynamic> toMap()
  {
    return {
      'id' : id,
      'parent_id': parentId,
      'deadline': deadline,
      'description': description,
      'priority': priority,
      'name' : name,
      'project_id' : projectId,
    };
  }
}