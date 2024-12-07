import 'package:rewardly/Data/models/project_model.dart';
import 'package:rewardly/Data/services/firestore_project_service.dart';

class ProjectRepository {
  final FirestoreProjectService _projectService = FirestoreProjectService();

  Stream<List<ProjectModel>> getProjects() {
    return _projectService.getAll();
  }

  Future<ProjectModel> getProject(String projectId) async {
    return await _projectService.get(projectId);
  }

  Future<void> createProject(ProjectModel projectModel) async {
    await _projectService.add(projectModel);
  }

  Future<void> updateProject(ProjectModel projectModel) async {
    await _projectService.update(projectModel);
  }
}
