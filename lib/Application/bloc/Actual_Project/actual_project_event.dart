part of 'actual_project_bloc.dart';

abstract class ActualProjectEvent {}

class ProjectSelected extends ActualProjectEvent {
  final Project project;

  ProjectSelected(this.project);
}

class ProjectUnselected extends ActualProjectEvent {}

class UpdateActualProject extends ActualProjectEvent {
  final Project project;

  UpdateActualProject(this.project);
}