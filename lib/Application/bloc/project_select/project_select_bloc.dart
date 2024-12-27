import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'project_select_event.dart';
part 'project_select_state.dart';

class ProjectSelectBloc extends Bloc<ProjectSelectEvent, ProjectSelectState> {
  ProjectSelectBloc() : super(ProjectSelectInitial("")) {
    on<ProjectSelectSwitch>((event, emit) {
      print("test:" + event.value);
      emit(ProjectSelectInitial(event.value));
    });
  }
}
