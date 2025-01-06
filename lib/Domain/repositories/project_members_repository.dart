import 'package:rewardly/Data/models/project_members_entity.dart';
import 'package:rewardly/Data/services/firestore_project_members_service.dart';
import 'package:rewardly/Domain/repositories/project_repository.dart';


class ProjectMembersRepository extends ProjectRepository {
  final ProjectMembersService _projectMembersService = ProjectMembersService();

  Future<void> addMembers(ProjectMembersEntity project) {
    return _projectMembersService.addMembers(project);
  }

  Future<List<ProjectMembersEntity>> getProjectMembers(String projectId) async {
    return await _projectMembersService.getProjectMembers(projectId);
  }
}
