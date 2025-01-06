part of 'project_member_bloc.dart';

abstract class ProjectMembersEvent extends Equatable {
  const ProjectMembersEvent();

  @override
  List<Object> get props => [];
}

class ProjectMemberLoad extends ProjectMembersEvent {
  final String projectId;

  const ProjectMemberLoad(this.projectId);

  @override
  List<Object> get props => [projectId];
}

class ProjectMembersCreate extends ProjectMembersEvent {
  final ProjectMembersEntity projectMembers;
  final String projectId;

  const ProjectMembersCreate(this.projectMembers, this.projectId);

  @override
  List<Object> get props => [projectMembers];
}

class ProjectMembersUpdate extends ProjectMembersEvent {
  final ProjectMembersEntity projectMembers;

  const ProjectMembersUpdate(this.projectMembers);

  @override
  List<Object> get props => [projectMembers];
}

class ProjectMembersDelete extends ProjectMembersEvent {
  final ProjectMembersEntity projectMembers;

  const ProjectMembersDelete(this.projectMembers);

  @override
  List<Object> get props => [projectMembers];
}

class ProjectMembersSearch extends ProjectMembersEvent {
  final String pseudo;

  const ProjectMembersSearch(this.pseudo);

  @override
  List<Object> get props => [pseudo];
}

class ProjectMembersSearchReset extends ProjectMembersEvent {}
