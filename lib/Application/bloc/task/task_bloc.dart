import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rewardly/Data/models/sub_task_entity.dart';
import 'package:rewardly/Data/models/task_entity.dart';
import 'package:rewardly/Domain/repositories/task_repository.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskRepository taskRepository = TaskRepository();
  late final StreamSubscription<List<Task>> _tasksSubscription;

  TaskBloc() : super(TaskState([])) {

    _tasksSubscription = taskRepository.getTasks().listen((tasks) {
      add(AddTaskToLists(tasks));
    });

    on<AddTask>((event, emit) {
      emit(TaskState([...state.tasks, event.task]));
    });

    on<AddTaskToLists>((event, emit) {
      final updatedTasks = [...state.tasks];

      for (var newTask in event.tasks) {
        final existingIndex = updatedTasks.indexWhere((task) => task.id == newTask.id);
        if (existingIndex != -1) {
          updatedTasks[existingIndex] = newTask;
        } else {
          updatedTasks.add(newTask);
        }
      }
      emit(TaskState(updatedTasks));
    });

    on<AddSubTask>((event, emit) {
      taskRepository.addSubTask(event.task);
    });


    on<GetTasks>((event, emit) async {
      final tasks = await taskRepository.getTasks().first;
      emit(TaskState(tasks));
    });

    on<GetTasksByProjectId>((event,emit) async {
      final tasks = await taskRepository.getTasksByProjectId(event.projectId).first;
      emit(TaskState(tasks));
    });

    on<UpdateTask>((event, emit) {
      taskRepository.updateTask(event.task);
      final updatedTasks = state.tasks.map((task) {
        return task.name == event.task.name ? event.task : task;
      }).toList();
      emit(TaskState(updatedTasks));
    });

    on<UpdateSubTask>((event, emit) {
      taskRepository.updateSubTask(event.task);
    });


    on<RemoveSubTask>((event, emit) {
      taskRepository.removeSubTask(event.task);

    });

    on<RemoveTask>((event, emit) {
      taskRepository.deleteTask(event.task.id);
      emit(TaskState(state.tasks.where((task) => task != event.task).toList()));
    });

    on<Clear>((event, emit) {
      emit(TaskState([]));
    });

    @override
    Future<void> close() {
      _tasksSubscription.cancel();
      return super.close();
    }

  }
}
