part of 'task_bloc.dart';

abstract class TaskEvent {}

class AddTask extends TaskEvent {
  final Task task;
  AddTask(this.task);
}

class AddTasks extends TaskEvent{
  final List<Task> tasks;
  AddTasks(this.tasks);
}

class UpdateTask extends TaskEvent {
  final Task task;
  UpdateTask(this.task);
}

class RemoveTask extends TaskEvent {
  final Task task;
  RemoveTask(this.task);
}