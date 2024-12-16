import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../Data/models/project_entity.dart';
import '../../../Domain/repositories/project_repository.dart';

part 'add_event.dart';
part 'add_state.dart';

class AddBloc extends Bloc<AddEvent, AddState> {
  final ProjectRepository _projectRepository = ProjectRepository();
  AddBloc() : super(AddInitial()) {
    on<AddRequested>(_OnAddRequested);
  }

  Future<void> _OnAddRequested(AddRequested event, Emitter<AddState> emit) async {
    emit(AddLoading());
    try {
      await _projectRepository.createProject(event.project);
      emit(AddSuccess());
    } catch (e) {
      emit(AddFailure(error: _mapErrorToMessage(e)));
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
