import 'package:rewardly/Data/models/project_entity.dart';
import 'package:rewardly/Data/models/project_model.dart';
import 'package:rewardly/Data/services/firestore_project_service.dart';

class ProjectRepository {
  final FirestoreProjectService _projectService = FirestoreProjectService();

  Stream<List<Project>> getProjects() {
    return _projectService.getAll().map((projectModels) {
      return projectModels
          .map((projectModel) => projectModelToProject(projectModel))
          .toList();
    });
  }

  Future<Project> getProject(String projectId) async {
    final projectModel = await _projectService.get(projectId);
    return projectModelToProject(projectModel);
  }

  Future<void> createProject(Project project) async {
    await _projectService.add(projectToProjectModel(project));
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

  ProjectModel projectToProjectModel(Project project) {
    return ProjectModel(
      name: project.name,
      id: project.id,
      reward: project.reward,
    );
  }
}
