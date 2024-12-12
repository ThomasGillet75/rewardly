
class ProjectModel{
  String id;
  String name;
  String reward;

  ProjectModel({required this.id, required this.name, this.reward = ""});

  factory ProjectModel.fromMap(Map<String, dynamic> data){
    return ProjectModel(
      id: data['project_id'],
      name: data['name'],
      reward: data['reward'] ?? "",
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'project_id': id,
      'name': name,
      'reward': reward
    };
  }
}