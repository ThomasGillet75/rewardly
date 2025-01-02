import 'package:rewardly/Data/models/project_entity.dart';
import 'package:rewardly/Data/models/project_model.dart';
import 'package:rewardly/Data/services/firestore_project_service.dart';

import '../../Data/services/firestore_project_members_service.dart';

class ProjectRepository {
  final FirestoreProjectService _projectService = FirestoreProjectService();
  final ProjectMembersService _projectMembersService = ProjectMembersService();

  Future<Stream<List<Project>>> getProjects() async {
    return _projectService.getAll().map((projectModels) {
      return projectModels.map((projectModel) => projectModelToProject(projectModel)).toList();
    });
  }

  Future<Project> getProject(String projectId) async {
    final projectModel = await _projectService.get(projectId);
    return projectModelToProject(projectModel);
  }

  Future<List<Project>> getProjectsByUserId(String userId) async {
    final projectModels = await _projectService.getProjectsByUserId(userId);
    return projectModels.map((projectModel) => projectModelListToProject(projectModel)).toList();
  }

  Future<void> createProject(Project project) async {
    await _projectService.add(projectToProjectModel(project));
    await _projectMembersService.addOwner(project.id);

  }

  Future<void> updateProject(Project project) async {
    await _projectService.update(projectToProjectModel(project));
  }

  Project projectModelToProject(ProjectModel projectModel) {
    return Project(
      name: projectModel.name,
      id: projectModel.id,
      reward: projectModel.reward,
    );
  }

  Project projectModelListToProject(List<ProjectModel> projectModel) {
    return Project(
      name: projectModel[0].name,
      id: projectModel[0].id,
      reward: projectModel[0].reward,
    );
  }

  ProjectModel projectToProjectModel(Project project) {
    return ProjectModel(
      name: project.name,
      id: project.id,
      reward: project.reward,
    );
  }

}

