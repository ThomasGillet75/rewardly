part of 'date_select_bloc.dart';

class DateSelectState extends Equatable {
  const DateSelectState();

  @override
  List<Object?> get props => [];
}

class DateSelectInitial extends DateSelectState {
  DateTime? selectedDate;

  DateSelectInitial(this.selectedDate);

  @override
  List<Object?> get props => [selectedDate];
}
