import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rewardly/Data/models/sub_task_entity.dart';
import 'package:rewardly/Data/models/task_entity.dart';
import 'package:rewardly/Domain/repositories/task_repository.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskRepository taskRepository = TaskRepository();

  TaskBloc() : super(TaskInitial()) {
    on<AddTask>(_onAddTask);
    on<AddTaskToLists>(_onAddTaskTaskToLists);
    on<AddSubTask>(_onAddSubTask);
    on<GetTasks>(_onGetTasks);
    on<GetTasksByProjectId>(_onGetTasksByProjectId);
    on<UpdateTask>(_onUpdateTask);
    on<UpdateSubTask>(_onUpdateSubTask);
    on<RemoveSubTask>(_onRemoveSubTask);
    on<RemoveTask>(_onRemoveTask);
    on<Clear>(_onClear);
  }

  void _onAddTask(AddTask event, Emitter<TaskState> emit) {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      final updatedTasks = [...currentState.tasks, event.task];
      emit(TaskLoaded(updatedTasks));
    }
  }

  void _onAddTaskTaskToLists(AddTaskToLists event, Emitter<TaskState> emit) {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      final updatedTasks = [...currentState.tasks];
      for (var newTask in event.tasks) {
        final existingIndex = updatedTasks.indexWhere((task) => task.id == newTask.id);
        if (existingIndex != -1) {
          updatedTasks[existingIndex] = newTask;
        } else {
          updatedTasks.add(newTask);
        }
      }
      emit(TaskLoaded(updatedTasks));
    }
  }

  void _onAddSubTask(AddSubTask event, Emitter<TaskState> emit) {
    taskRepository.addSubTask(event.task);
  }

  Future<void> _onGetTasks(GetTasks event, Emitter<TaskState> emit) async {
    final tasks = await taskRepository.getTasks().first;
    emit(TaskLoaded(tasks));
  }

  Future<void> _onGetTasksByProjectId(GetTasksByProjectId event, Emitter<TaskState> emit) async {
    final tasks = await taskRepository.getTasksByProjectId(event.projectId).first;
    emit(TaskLoaded(tasks));
  }

  void _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) {
    taskRepository.updateTask(event.task);
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      final updatedTasks = currentState.tasks.map((task) {
        return task.name == event.task.name ? event.task : task;
      }).toList();
      emit(TaskLoaded(updatedTasks));
    }
  }

  void _onUpdateSubTask(UpdateSubTask event, Emitter<TaskState> emit) {
    taskRepository.updateSubTask(event.task);
  }

  void _onRemoveSubTask(RemoveSubTask event, Emitter<TaskState> emit) {
    taskRepository.removeSubTask(event.task);
  }

  void _onRemoveTask(RemoveTask event, Emitter<TaskState> emit) {
    taskRepository.deleteTask(event.task.id);
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      emit(TaskLoaded(currentState.tasks.where((task) => task != event.task).toList()));
    }
  }

  void _onClear(Clear event, Emitter<TaskState> emit) {
    emit(TaskLoaded([]));
  }
}