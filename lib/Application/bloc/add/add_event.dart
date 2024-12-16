part of 'add_bloc.dart';

abstract class AddEvent extends Equatable {
  const AddEvent();

  @override
  List<Object> get props => [];
}

class AddRequested extends AddEvent {
  final Project? project;
  final Task? task;

  const AddRequested._({this.project, this.task});

  const AddRequested.forTask({required Task task}) : this._(task: task);
  const AddRequested.forProject({required Project project}) : this._(project: project);
}

