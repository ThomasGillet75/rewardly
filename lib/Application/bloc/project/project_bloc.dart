import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rewardly/Core/utils/interface.dart';
import 'package:rewardly/Data/models/project_entity.dart';
import 'package:rewardly/Domain/repositories/project_repository.dart';

part 'project_event.dart';

part 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final ProjectRepository _projectRepository = ProjectRepository();



  ProjectBloc() : super(ProjectInitial()) {
    on<GetProjects>(_onGetProjects);
    on<AddProject>(_onAddProject);
    on<AddProjects>(_onAddProjects);
    on<AddReward>(_onAddReward);
    on<AddProjectToDB>(_onAddProjectToDB);
  }

  Future<void> _onGetProjects(GetProjects event,
      Emitter<ProjectState> emit) async {
    emit(ProjectLoading());
    try {
      final projects = await _projectRepository
          .getProjects()
          .first;
      emit(ProjectLoaded(projects));
    } catch (e) {
      emit(ProjectFailure('Failed to load projects: $e'));
    }
  }

  void _onAddProject(AddProject event, Emitter<ProjectState> emit) {
    if (state is ProjectLoaded) {
      final currentState = state as ProjectLoaded;
      final updatedProjects = [...currentState.projects, event.project];
      emit(ProjectLoaded(updatedProjects));
    } else {
      emit(ProjectFailure('Cannot add project in the current state.'));
    }
  }


  void _onAddProjects(AddProjects event, Emitter<ProjectState> emit) {
    if (state is ProjectLoaded) {
      final currentState = state as ProjectLoaded;
      final updatedProjects = [...currentState.projects];
      for (var newProject in event.projects) {
        final existingIndex = updatedProjects.indexWhere((project) =>
        project.id == newProject.id);
        if (existingIndex != -1) {
          updatedProjects[existingIndex] = newProject;
        } else {
          updatedProjects.add(newProject);
        }
      }
      emit(ProjectLoaded(updatedProjects));
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
        emit(ProjectLoaded(updatedProjects));
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
        emit(ProjectLoaded(updatedProjects));
      } catch (e) {
        emit(ProjectFailure('Failed to add project: $e'));
      }
    } else {
      emit(ProjectFailure('Cannot add project in the current state.'));
    }
  }
}