import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'toggle_event.dart';
part 'toggle_state.dart';

class ToggleBloc extends Bloc<ToggleEvent, ToggleState> {
  ToggleBloc() : super(const ToggleInitial(true)) {
    on<ToggleSwitch>((event, emit) {
      emit(ToggleInitial(!(state as ToggleInitial).isMesTachesSelected));
    });
  }
}
