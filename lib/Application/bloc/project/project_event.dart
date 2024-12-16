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

class AddReward extends ProjectEvent {
  final Project project;

  AddReward(this.project);
}

class GetProjects extends ProjectEvent {}
