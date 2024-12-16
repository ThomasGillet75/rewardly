part of 'add_bloc.dart';

abstract class AddEvent extends Equatable {
  const AddEvent();

  @override
  List<Object> get props => [];
}

class AddRequested extends AddEvent {
  final Project project;

  const AddRequested({required this.project});
}
