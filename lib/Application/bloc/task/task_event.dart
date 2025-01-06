part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class AddTask extends TaskEvent {
  final Task task;

  const AddTask(this.task);

  @override
  List<Object?> get props => [task];
}

class AddTaskToLists extends TaskEvent {
  final List<Task> tasks;

  const AddTaskToLists(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class AddSubTask extends TaskEvent {
  final SubTask task;

  const AddSubTask(this.task);

  @override
  List<Object?> get props => [task];
}

class GetTasks extends TaskEvent {
  final String userId;

  const GetTasks(this.userId);

  @override
  List<Object?> get props => [userId];
}

class GetTasksByProjectId extends TaskEvent {
  final String projectId;

  const GetTasksByProjectId(this.projectId);

  @override
  List<Object?> get props => [projectId];
}

class UpdateTask extends TaskEvent {
  final Task task;

  const UpdateTask(this.task);

  @override
  List<Object?> get props => [task];
}

class UpdateSubTask extends TaskEvent {
  final SubTask task;

  const UpdateSubTask(this.task);

  @override
  List<Object?> get props => [task];
}

class RemoveSubTask extends TaskEvent {
  final SubTask task;

  const RemoveSubTask(this.task);

  @override
  List<Object?> get props => [task];
}

class RemoveTask extends TaskEvent {
  final Task task;

  const RemoveTask(this.task);

  @override
  List<Object?> get props => [task];
}

class Clear extends TaskEvent {}

class AddTaskToDB extends TaskEvent {
  final Task task;

  const AddTaskToDB(this.task);

  @override
  List<Object?> get props => [task];
}
