import 'package:rewardly/Data/models/task_model.dart';
import 'package:rewardly/Data/repositories/project_repository.dart';
import 'package:rewardly/Data/repositories/task_repository.dart';

class HomepageViewModel{
  TaskRepository taskRepository = TaskRepository();
  ProjectRepository projectRepository = ProjectRepository();

  Future<void> createTask()
  async {
    TaskModel taskModel = TaskModel(id: "1", parentId: "0", name: "taks", projectId: "zto85e0YdjcUzp1XXO1R " );
    print(projectRepository.getProjects());
    taskRepository.createTask(taskModel.toMap());
  }
}