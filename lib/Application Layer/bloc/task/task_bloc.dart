import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rewardly/Data/models/task_entity.dart';
import 'package:rewardly/Domain/repositories/task_repository.dart';

part 'task_event.dart';
part 'task_state.dart';


class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskRepository taskRepository = TaskRepository();

  TaskBloc() : super(TaskState([])) {

    on<AddTask>((event, emit) {
      emit(TaskState([...state.tasks, event.task]));
    });

    on<AddTasks>((event,emit){
      emit(TaskState([...state.tasks,...event.tasks]));
    });

    on<GetTasks>((event, emit) async {
      final tasks = await taskRepository.getTasks().first;
      print("\x1B[32mProjects found.\x1B[0m");
      emit(TaskState([...state.tasks, ...tasks]));
    });

    on<UpdateTask>((event, emit) {
      final updatedTasks = state.tasks.map((task) {
        return task.name == event.task.name ? event.task : task;
      }).toList();
      emit(TaskState(updatedTasks));
    });

    on<RemoveTask>((event, emit) {
      emit(TaskState(state.tasks.where((t) => t != event.task).toList()));
    });
  }
}
