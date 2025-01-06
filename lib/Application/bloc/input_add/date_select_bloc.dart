import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


part 'date_select_event.dart';
part 'date_select_state.dart';

class DateSelectBloc extends Bloc<DateSelectEvent, DateSelectState> {
  DateSelectBloc() : super(DateSelectInitial(null)) {
    on<DateSelectSwitch>((event, emit) {
      emit(DateSelectInitial(event.value));});
  }
}
