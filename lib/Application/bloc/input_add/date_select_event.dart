part of 'date_select_bloc.dart';

abstract class DateSelectEvent extends Equatable {
  const DateSelectEvent();

  @override
  List<Object> get props => [];
}

class DateSelectSwitch extends DateSelectEvent {
  final DateTime value;

  DateSelectSwitch({required this.value});

  @override
  List<Object> get props => [value];
}