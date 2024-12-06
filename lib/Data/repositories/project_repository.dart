import 'package:rewardly/Data/models/project_model.dart';
import 'package:rewardly/Data/services/firestore_service.dart';

class ProjectRepository {
  final FirestoreService _firestoreService = FirestoreService();

  Future<List<ProjectModel>> getProjects(){
    return _firestoreService.getProjects().then((projects) {
      return projects.map((doc) => ProjectModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
    });
  }
}