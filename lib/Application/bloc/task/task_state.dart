part of 'task_bloc.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;
  final bool isProjectContext;
  final String? projectId;

  const TaskLoaded({
    required this.tasks,
    this.isProjectContext = false,
    this.projectId,
  });

  @override
  List<Object?> get props => [tasks, isProjectContext, projectId];
}

class TaskFailure extends TaskState {
  final String error;

  const TaskFailure(this.error);

  @override
  List<Object?> get props => [error];
}
