import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rewardly/Data/models/project_entity.dart';
import 'package:rewardly/Data/models/project_members_entity.dart';
import 'package:rewardly/Data/models/user_entity.dart';
import 'package:rewardly/Domain/repositories/project_members_repository.dart';
import 'package:rewardly/Domain/repositories/user_repository.dart';

part 'project_member_event.dart';
part 'project_member_state.dart';

class ProjectMemberBloc extends Bloc<ProjectMembersEvent, ProjectMembersState> {
  final ProjectMembersRepository projectMembersRepository =
      ProjectMembersRepository();
  final UserRepository userRepository = UserRepository();

  ProjectMemberBloc() : super(ProjectMembersInitial()) {
    on<ProjectMemberLoad>(_onProjectMembersLoad);
    on<ProjectMembersCreate>(_onAddProjectMembers);
    on<ProjectMembersSearch>(_onSearchInFriends);
  }

  Future<void> _onProjectMembersLoad(
      ProjectMemberLoad event, Emitter<ProjectMembersState> emit) async {
    emit(ProjectMembersLoading());
    try {
      final users = await userRepository.getUsersNotInProject(event.projectId);
      emit(ProjectMembersLoaded(users));
    } catch (e) {
      emit(ProjectMembersFailure(
          'Error loading project members: ${e.toString()}'));
    }
  }

  Future<void> _onAddProjectMembers(
      ProjectMembersCreate event, Emitter<ProjectMembersState> emit) async {
    try {
      emit(ProjectMembersLoading());
      await projectMembersRepository.addMembers(event.projectMembers);
      final users = userRepository.getUsers();
    } catch (e) {
      emit(ProjectMembersFailure(
          'Error adding project members: ${e.toString()}'));
    }
  }

  Future<void> _onSearchInFriends(
      ProjectMembersSearch event, Emitter<ProjectMembersState> emit) async {
    emit(ProjectMembersLoading());
    try {
      final users = await userRepository.searchUsersNotInProject(event.pseudo);
      emit(ProjectMembersLoaded(users));
    } catch (e) {
      emit(ProjectMembersFailure(
          'Error searching project members: ${e.toString()}'));
    }
  }
}
