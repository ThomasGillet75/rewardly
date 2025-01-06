import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'project_select_event.dart';
part 'project_select_state.dart';

class ProjectSelectBloc extends Bloc<ProjectSelectEvent, ProjectSelectState> {
  ProjectSelectBloc() : super(ProjectSelectInitial("")) {
    on<ProjectSelectSwitch>((event, emit) {
      emit(ProjectSelectInitial(event.value));
    });
  }
}
