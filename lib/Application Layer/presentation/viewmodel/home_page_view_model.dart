import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rewardly/Data/models/task_model.dart';
import 'package:rewardly/Domain/repositories/project_repository.dart';
import 'package:rewardly/Domain/repositories/task_repository.dart';

class HomepageViewModel {
  TaskRepository taskRepository = TaskRepository();
  ProjectRepository projectRepository = ProjectRepository();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createTask() async {
    DocumentReference projectRef =
        _firestore.collection('projects').doc('zto85e0YdjcUzp1XXO1R');
    TaskModel taskModel =
        TaskModel(id: "1", parentId: "0", name: "taks", projectRef: projectRef);
    taskRepository.createTask(taskModel);
  }

  Future<void> getProjects() async {

      var projects = projectRepository.getProjects();

      print("\x1B[31mNo projects found.\x1B[0m");

  }
}
