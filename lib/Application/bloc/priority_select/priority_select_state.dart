part of 'priority_select_bloc.dart';

abstract class PrioritySelectState extends Equatable {
  const PrioritySelectState();

  @override
  List<Object?> get props => [];
}

class PrioritySelectInitial extends PrioritySelectState {
  TaskPriority selectedPriority;

  PrioritySelectInitial(this.selectedPriority);

  @override
  List<Object?> get props => [selectedPriority];
}
