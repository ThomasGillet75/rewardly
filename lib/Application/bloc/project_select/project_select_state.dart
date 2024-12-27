part of 'project_select_bloc.dart';

abstract class ProjectSelectState extends Equatable {
  const ProjectSelectState();

  @override
  List<Object?> get props => [];
}

class ProjectSelectInitial extends ProjectSelectState {
  String selectedProject;

  ProjectSelectInitial(this.selectedProject);

  @override
  List<Object?> get props => [selectedProject];
}
