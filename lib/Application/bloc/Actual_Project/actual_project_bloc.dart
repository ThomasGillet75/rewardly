import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rewardly/Domain/repositories/project_repository.dart';

import '../../../Data/models/project_entity.dart';

part 'actual_project_event.dart';

part 'actual_project_state.dart';

class ActualProjectBloc extends Bloc<ActualProjectEvent, ActualProjectState> {
  ProjectRepository _projectRepository = ProjectRepository();

  ActualProjectBloc() : super(ActualProjectInitial()) {
    on<ProjectSelected>(_onProjectSelected);
    on<ProjectUnselected>(_onProjectUnselected);
    on<UpdateActualProject>(_onUpdateActualProject);
  }

  void _onProjectSelected(
      ProjectSelected event, Emitter<ActualProjectState> emit) {
    emit(ProjectSelectionSuccess(event.project));
  }

  void _onProjectUnselected(
      ProjectUnselected event, Emitter<ActualProjectState> emit) {
    emit(ProjectUnselectedSuccess());
  }

  Future<void> _onUpdateActualProject(
      UpdateActualProject event, Emitter<ActualProjectState> emit) async {
    await _projectRepository.updateProject(event.project);
    emit(ActualProjectUpdated(event.project));
  }
}
