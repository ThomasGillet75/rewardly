part of 'project_select_bloc.dart';

abstract class ProjectSelectEvent extends Equatable {
  const ProjectSelectEvent();

  @override
  List<Object> get props => [];
}

class ProjectSelectSwitch extends ProjectSelectEvent {
  final String value;

  ProjectSelectSwitch({required this.value});

  @override
  List<Object> get props => [value];
}
