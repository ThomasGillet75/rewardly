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
  StreamSubscription? _taskSubscription;

  TaskBloc() : super(TaskInitial()) {
    on<AddTask>(_onAddTask);
    on<AddTaskToLists>(_onAddTaskToLists);
    on<AddSubTask>(_onAddSubTask);
    on<GetTasks>(_onGetTasks);
    on<GetTasksByProjectId>(_onGetTasksByProjectId);
    on<UpdateTask>(_onUpdateTask);
    on<UpdateSubTask>(_onUpdateSubTask);
    on<RemoveSubTask>(_onRemoveSubTask);
    on<RemoveTask>(_onRemoveTask);
    on<Clear>(_onClear);
    on<AddTaskToDB>(_onAddTaskToDB);
  }

  // Add a single task
  void _onAddTask(AddTask event, Emitter<TaskState> emit) {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      final updatedTasks = [...currentState.tasks, event.task];
      emit(TaskLoaded(
        tasks: updatedTasks,
        isProjectContext: currentState.isProjectContext,
        projectId: currentState.projectId,
      ));
    } else {
      emit(TaskFailure('Cannot add task: Current state is not TaskLoaded.'));
    }
  }

  // Add multiple tasks
  void _onAddTaskToLists(AddTaskToLists event, Emitter<TaskState> emit) {
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
      emit(TaskLoaded(
        tasks: updatedTasks,
        isProjectContext: currentState.isProjectContext,
        projectId: currentState.projectId,
      ));
    } else {
      emit(TaskFailure('Cannot add tasks: Current state is not TaskLoaded.'));
    }
  }

  // Add a subtask
  Future<void> _onAddSubTask(AddSubTask event, Emitter<TaskState> emit) async {
    try {
      taskRepository.addSubTask(event.task);
      add(GetTasksByProjectId(event.task.projectId)); // Optionally refresh tasks
    } catch (e) {
      emit(TaskFailure('Failed to add subtask: $e'));
    }
  }

  // Get all tasks
  Future<void> _onGetTasks(GetTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await taskRepository.getTasks().first;
      emit(TaskLoaded(
        tasks: tasks,
        isProjectContext: false,
        projectId: null,
      ));
    } catch (e) {
      emit(TaskFailure('Failed to load tasks: $e'));
    }
  }

  // Get tasks by project ID
  Future<void> _onGetTasksByProjectId(GetTasksByProjectId event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await taskRepository.getTasksByProjectId(event.projectId).first;
      emit(TaskLoaded(
        tasks: tasks,
        isProjectContext: true,
        projectId: event.projectId,
      ));
    } catch (e) {
      emit(TaskFailure('Failed to load tasks for project ${event.projectId}: $e'));
    }
  }

  // Update a task
  Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    try {
      await taskRepository.updateTask(event.task);
      if (state is TaskLoaded) {
        final currentState = state as TaskLoaded;
        final updatedTasks = currentState.tasks.map((task) {
          return task.id == event.task.id ? event.task : task;
        }).toList();
        emit(TaskLoaded(
          tasks: updatedTasks,
          isProjectContext: currentState.isProjectContext,
          projectId: currentState.projectId,
        ));
      }
    } catch (e) {
      emit(TaskFailure('Failed to update task: $e'));
    }
  }

  // Update a subtask
  Future<void> _onUpdateSubTask(UpdateSubTask event, Emitter<TaskState> emit) async {
    try {
      taskRepository.updateSubTask(event.task);
    } catch (e) {
      emit(TaskFailure('Failed to update subtask: $e'));
    }
  }

  // Remove a subtask
  Future<void> _onRemoveSubTask(RemoveSubTask event, Emitter<TaskState> emit) async {
    try {
      taskRepository.removeSubTask(event.task);
    } catch (e) {
      emit(TaskFailure('Failed to remove subtask: $e'));
    }
  }

  // Remove a task
  Future<void> _onRemoveTask(RemoveTask event, Emitter<TaskState> emit) async {
    try {
      await taskRepository.deleteTask(event.task.id);
      if (state is TaskLoaded) {
        final currentState = state as TaskLoaded;
        final updatedTasks = currentState.tasks.where((task) => task.id != event.task.id).toList();
        emit(TaskLoaded(
          tasks: updatedTasks,
          isProjectContext: currentState.isProjectContext,
          projectId: currentState.projectId,
        ));
      }
    } catch (e) {
      emit(TaskFailure('Failed to remove task: $e'));
    }
  }

  // Clear all tasks
  void _onClear(Clear event, Emitter<TaskState> emit) {
    emit(TaskLoaded(
      tasks: [],
      isProjectContext: false,
      projectId: null,
    ));
  }

  Future<void> _onAddTaskToDB(AddTaskToDB event, Emitter<TaskState> emit) async {
    try {
      if (state is TaskLoaded) {
        final currentState = state as TaskLoaded;

        // Emit loading to reflect the current state
        emit(TaskLoading());

        // Add the task to the database
        await taskRepository.createTask(event.task);

        // Reload tasks depending on the current context
        if (currentState.isProjectContext && currentState.projectId != null) {
          // Reload tasks for the current project
          final tasks = await taskRepository.getTasksByProjectId(currentState.projectId!).first;
          emit(TaskLoaded(
            tasks: tasks,
            isProjectContext: true,
            projectId: currentState.projectId,
          ));
        } else {
          // Reload all tasks in a global context
          final tasks = await taskRepository.getTasks().first;
          emit(TaskLoaded(
            tasks: tasks,
            isProjectContext: false,
            projectId: null,
          ));
        }
      } else {
        emit(TaskFailure('Current state is not TaskLoaded. Cannot add task.'));
      }
    } catch (e) {
      emit(TaskFailure('Failed to add task: $e'));
    }
  }



  @override
  Future<void> close() {
    _taskSubscription?.cancel();
    return super.close();
  }
}
