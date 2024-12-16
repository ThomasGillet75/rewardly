import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rewardly/Data/models/project_entity.dart';
import 'package:rewardly/Domain/repositories/project_repository.dart';

part 'project_event.dart';

part 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final ProjectRepository _projectRepository = ProjectRepository();
  late final StreamSubscription<List<Project>> _projectsSubscription;

  ProjectBloc() : super(ProjectState([])) {

    _projectsSubscription = _projectRepository.getProjects().listen((projects) {
      add(AddProjects(projects));
    });

    on<AddProject>((event, emit) {
      emit(ProjectState([...state.projects, event.project]));
    });

    on<AddProjects>((event, emit) {
      final updatedProjects = [...state.projects];
      for (var newProject in event.projects) {
        final existingIndex = updatedProjects.indexWhere((project) => project.id == newProject.id);
        if (existingIndex != -1) {
          updatedProjects[existingIndex] = newProject;
        } else {
          updatedProjects.add(newProject);
        }
      }
      emit(ProjectState(updatedProjects));
    });

    on<AddReward>((event, emit) {
      _projectRepository.updateProject(event.project);
      final updatedProjects = state.projects.map((project) {
        return project.id == event.project.id ? event.project : project;
      }).toList();
      emit(ProjectState(updatedProjects));
    });

    on<GetProjects>((event, emit) async {
      final projects = await _projectRepository.getProjects().first;
      emit(ProjectState(projects));
    });

    @override close() {
      _projectsSubscription.cancel();
      super.close();
    }
  }
}