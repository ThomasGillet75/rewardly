import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rewardly/Core/task_priority_enum.dart';

part 'priority_select_event.dart';
part 'priority_select_state.dart';

class PrioritySelectBloc
    extends Bloc<PrioritySelectEvent, PrioritySelectState> {
  PrioritySelectBloc() : super(PrioritySelectInitial(TaskPriority.none)) {
    on<PrioritySelectSwitch>((event, emit) {
      emit(PrioritySelectInitial(event.value));
    });
  }
}
