



class ProjectMembersEntity {

  String projectId;
  String userId;

  ProjectMembersEntity({
    required this.projectId,
    required this.userId,

  });
  factory ProjectMembersEntity.fromMap(Map<String, dynamic> map) => ProjectMembersEntity(

    projectId: map["project_id"],
    userId: map["user_id"],

  );


  Map<String, dynamic> toMap() => {

    "project_id": projectId,
    "user_id": userId,

  };
}