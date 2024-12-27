part of 'project_bloc.dart';

abstract class ProjectEvent {}

class AddProject extends ProjectEvent {
  final Project project;

  AddProject(this.project);
}

class AddProjects extends ProjectEvent {
  final List<Project> projects;

  AddProjects(this.projects);
}

class AddProjectToDB extends ProjectEvent {
  final Project project;

  AddProjectToDB(this.project);
}


class AddReward extends ProjectEvent {
  final Project project;

  AddReward(this.project);
}

class GetProjects extends ProjectEvent {}
