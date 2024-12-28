import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rewardly/Application/bloc/priority_select/priority_select_bloc.dart';

import '../../../Core/task_priority_enum.dart';

part 'date_select_event.dart';
part 'date_select_state.dart';

class DateSelectBloc extends Bloc<DateSelectEvent, DateSelectState> {
  DateSelectBloc() : super(DateSelectInitial(null)) {
    on<DateSelectSwitch>((event, emit) {
      print("********************************");
      print("********************************");
      print("********************************");
      print(event.value);
      print("********************************");
      print("********************************");
      print("********************************");
      emit(DateSelectInitial(event.value));});
  }
}
