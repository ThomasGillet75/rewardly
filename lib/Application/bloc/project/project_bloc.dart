import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rewardly/Core/utils/interface.dart';
import 'package:rewardly/Data/models/project_entity.dart';
import 'package:rewardly/Domain/repositories/project_repository.dart';
import 'package:rewardly/Domain/repositories/user_repository.dart';

import '../../../Data/models/user_entity.dart';

part 'project_event.dart';

part 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final ProjectRepository _projectRepository = ProjectRepository();
  final UserRepository _userRepository = UserRepository();



  ProjectBloc() : super(ProjectInitial()) {
    on<GetProjects>(_onGetProjects);
    on<AddProject>(_onAddProject);
    on<AddProjects>(_onAddProjects);
    on<AddReward>(_onAddReward);
    on<AddProjectToDB>(_onAddProjectToDB);
  }
  Future<void> _onGetProjects(GetProjects event, Emitter<ProjectState> emit) async {
    emit(ProjectLoading());
    try {
      final users = await _userRepository.getUsers();
      final projectStream = await _projectRepository.getProjects();

      await for (final projects in projectStream) {
        emit(ProjectLoaded(projects, users));
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(ProjectFailure('Failed to load projects: $e'));
      }
    }
  }

  void _onAddProject(AddProject event, Emitter<ProjectState> emit) async {
    if (state is ProjectLoaded) {
      final currentState = state as ProjectLoaded;
      final updatedProjects = [...currentState.projects, event.project];
      final users = await _userRepository.getUsers();

      emit(ProjectLoaded(updatedProjects, users));
    } else {
      emit(ProjectFailure('Cannot add project in the current state.'));
    }
  }

  void _onAddProjects(AddProjects event, Emitter<ProjectState> emit) async {
    if (state is ProjectLoaded) {
      final currentState = state as ProjectLoaded;
      final updatedProjects = [...currentState.projects];
      for (var newProject in event.projects) {
        final existingIndex = updatedProjects.indexWhere((project) => project.id == newProject.id);
        if (existingIndex != -1) {
          updatedProjects[existingIndex] = newProject;
        } else {
          updatedProjects.add(newProject);
        }
      }
      final users = await _userRepository.getUsers();
      emit(ProjectLoaded(updatedProjects, users));
    } else {
      emit(ProjectFailure('Cannot add projects in the current state.'));
    }
  }

  Future<void> _onAddReward(AddReward event, Emitter<ProjectState> emit) async {
    if (state is ProjectLoaded) {
      final currentState = state as ProjectLoaded;
      try {
        await _projectRepository.updateProject(event.project);
        final updatedProjects = currentState.projects.map((project) {
          return project.id == event.project.id ? event.project : project;
        }).toList();
        final users = await _userRepository.getUsers();
        emit(ProjectLoaded(updatedProjects, users));
      } catch (e) {
        emit(ProjectFailure('Failed to update project: $e'));
      }
    } else {
      emit(ProjectFailure('Cannot add reward in the current state.'));
    }
  }

  Future<void> _onAddProjectToDB(AddProjectToDB event, Emitter<ProjectState> emit) async {
    if (state is ProjectLoaded) {
      final currentState = state as ProjectLoaded;
      try {
        await _projectRepository.createProject(event.project);
        final updatedProjects = [...currentState.projects, event.project];
        final users = await _userRepository.getUsers();
        emit(ProjectLoaded(updatedProjects, users));
      } catch (e) {
        emit(ProjectFailure('Failed to add project: $e'));
      }
    } else {
      emit(ProjectFailure('Cannot add project in the current state.'));
    }
  }
}