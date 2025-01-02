

import 'package:equatable/equatable.dart';

import '../../../Data/models/project_entity.dart';
import '../../../Data/models/project_members_entity.dart';
import '../../../Data/models/user_entity.dart';

abstract class ProjectMembersState extends Equatable {
  const ProjectMembersState();

  @override
  List<Object> get props => [];

}

class ProjectMembersInitial extends ProjectMembersState {}

class ProjectMembersLoading extends ProjectMembersState {}

class ProjectMembersLoad extends ProjectMembersState {
  final Project projectId;

  const ProjectMembersLoad(this.projectId);

  @override
  List<Object> get props => [projectId];
}

class ProjectMembersLoaded extends ProjectMembersState {
 final  List<Users> projectMembers;

  const ProjectMembersLoaded(this.projectMembers);

  @override
  List<Object> get props => [projectMembers];
}

class ProjectMembersSuccess extends ProjectMembersState {

  const ProjectMembersSuccess();

}


class ProjectMembersFailure extends ProjectMembersState {
  final String message;

  const ProjectMembersFailure(this.message);
}

