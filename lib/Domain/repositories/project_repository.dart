import 'package:rewardly/Data/models/project_entity.dart';
import 'package:rewardly/Data/models/project_model.dart';
import 'package:rewardly/Data/services/firestore_project_service.dart';

class ProjectRepository {
  final FirestoreProjectService _projectService = FirestoreProjectService();

  Future<List<Project>> getProjects() async {
    final projectModels = await _projectService.getAll().first;
    return projectModels.map((projectModel) {
      return projectModelToProject(projectModel);
    }).toList();
  }

  Future<Project> getProject(String projectId) async {
    final projectModel = await _projectService.get(projectId);
    return projectModelToProject(projectModel);
  }

  Future<void> createProject(ProjectModel projectModel) async {
    await _projectService.add(projectModel);
  }

  Future<void> updateProject(ProjectModel projectModel) async {
    await _projectService.update(projectModel);
  }

  Project projectModelToProject(ProjectModel projectModel) {
    return Project(
      name: projectModel.name,
      id: projectModel.id,
      reward: projectModel.reward,
    );
  }
}
