import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rewardly/Core/task_priority_enum.dart';
import 'package:rewardly/Core/utils/task_utils.dart';

part 'priority_select_event.dart';
part 'priority_select_state.dart';

class PrioritySelectBloc extends Bloc<PrioritySelectEvent, PrioritySelectState> {
  PrioritySelectBloc() : super(PrioritySelectInitial(TaskPriority.none)) {
    on<PrioritySelectSwitch>((event, emit) {
      emit(PrioritySelectInitial(event.value));
    });
  }
}

