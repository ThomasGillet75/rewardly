import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rewardly/Data/models/task_entity.dart';

import '../../../Core/task_priority_enum.dart';
import '../../../Data/models/project_entity.dart';
import '../../../Domain/repositories/project_repository.dart';
import '../../../Domain/repositories/task_repository.dart';
import '../priority_select/priority_select_bloc.dart';

part 'add_event.dart';
part 'add_state.dart';

class AddBloc extends Bloc<AddEvent, AddState> {
  final ProjectRepository _projectRepository = ProjectRepository();
  final TaskRepository _taskRepository = TaskRepository();
  AddBloc() : super(AddInitial()) {
    on<AddRequested>(_OnAddRequested);
  }

  Future<void> _OnAddRequested(AddRequested event, Emitter<AddState> emit) async {
    emit(AddLoading());
    if(event.project != null)
      {
        try {
          await _projectRepository.createProject(event.project!);
          emit(AddSuccess());
        } catch (e) {
          emit(AddFailure(error: _mapErrorToMessage(e)));
        }
      }
    else if(event.task != null)
      {
        try {
          await _taskRepository.createTask(event.task!);
          emit(AddSuccess());
          PrioritySelectInitial(TaskPriority.none);
        } catch (e) {
          emit(AddFailure(error: _mapErrorToMessage(e)));
        }
      }
  }

  String _mapErrorToMessage(dynamic error) {
    if (error is String) {
      return error;
    } else {
      return 'Unknown error';
    }
  }
}
