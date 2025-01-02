import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rewardly/Domain/repositories/project_repository.dart';

import '../../Data/models/project_entity.dart';
import '../../Data/models/project_members_entity.dart';
import '../../Data/services/firestore_project_members_service.dart';


class ProjectMembersRepository extends ProjectRepository {

  final ProjectMembersService _projectMembersService = ProjectMembersService();




  Future<void> addMembers(ProjectMembersEntity project) {
    return _projectMembersService.addMembers(project);
  }

  Future<List<ProjectMembersEntity>> getProjectMembers(String projectId) async {
    return await _projectMembersService.getProjectMembers(projectId);
  }

}
