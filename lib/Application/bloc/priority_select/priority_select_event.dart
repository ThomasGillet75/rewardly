part of 'priority_select_bloc.dart';

abstract class PrioritySelectEvent extends Equatable {
  const PrioritySelectEvent();

  @override
  List<Object> get props => [];
}

class PrioritySelectSwitch extends PrioritySelectEvent {
  final TaskPriority value;

  const PrioritySelectSwitch({required this.value});

  @override
  List<Object> get props => [value];
}
