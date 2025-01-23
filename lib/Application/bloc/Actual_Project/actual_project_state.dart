part of 'actual_project_bloc.dart';

abstract class ActualProjectState extends Equatable {
  const ActualProjectState();

  @override
  List<Object> get props => [];
}

class ActualProjectInitial extends ActualProjectState {}

class ProjectUnselectedSuccess extends ActualProjectState {}

class ProjectSelectionSuccess extends ActualProjectState {
  final Project project;

  const ProjectSelectionSuccess(this.project);

  @override
  List<Object> get props => [project];
}

class ActualProjectUpdated extends ActualProjectState {
  final Project project;

  const ActualProjectUpdated(this.project);

  @override
  List<Object> get props => [project];
}