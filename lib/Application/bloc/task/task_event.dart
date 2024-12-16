part of 'task_bloc.dart';

abstract class TaskEvent {}

class AddTask extends TaskEvent {
  final Task task;
  AddTask(this.task);
}

class AddTaskToLists extends TaskEvent{
  final List<Task> tasks;
  AddTaskToLists(this.tasks);
}

class AddSubTask extends TaskEvent {
  final SubTask task;
  AddSubTask(this.task);
}

class GetTasks extends TaskEvent{
}

class GetTasksByProjectId extends TaskEvent{
  final String projectId;
  GetTasksByProjectId(this.projectId);
}

class UpdateTask extends TaskEvent {
  final Task task;
  UpdateTask(this.task);
}

class UpdateSubTask extends TaskEvent {
  final SubTask task;
  UpdateSubTask(this.task);
}

class RemoveTask extends TaskEvent {
  final Task task;
  RemoveTask(this.task);
}

class RemoveSubTask extends TaskEvent {
  final SubTask task;
  RemoveSubTask(this.task);
}

class Clear extends TaskEvent {
}