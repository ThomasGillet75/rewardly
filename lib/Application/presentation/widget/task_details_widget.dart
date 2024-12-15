import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rewardly/Application/bloc/task/task_bloc.dart';
import 'package:rewardly/Application/presentation/widget/filtering_widget.dart';
import 'package:rewardly/Core/task_priority_enum.dart';
import 'package:rewardly/Core/utils/date_utils.dart';
import 'package:rewardly/Core/utils/task_utils.dart';
import 'package:rewardly/Data/models/sub_task_entity.dart';
import 'package:rewardly/Data/models/task_entity.dart';

import '../../../core/color.dart';

class TaskDetailsWidget extends StatefulWidget {
  const TaskDetailsWidget({super.key, required this.task});

  final Task task;

  @override
  State<TaskDetailsWidget> createState() => _TaskDetailsWidgetState();
}

class _TaskDetailsWidgetState extends State<TaskDetailsWidget> {
  late Task _currentTask;

  @override
  void initState() {
    super.initState();
    _currentTask = widget.task;
  }

  // Update the task in the bloc
  // task: the task to update
  void _updateTask(Task task) {
    BlocProvider.of<TaskBloc>(context).add(UpdateTask(task));
    setState(() {
      _currentTask = task;
    });
  }

  // Update the priority of the task
  // value: the new priority
  void _updateFiltering(String? value) {
    if (value == null) return;
    final TaskPriority priority = TaskPriority.values.firstWhere(
      (element) => TaskUtils.priorityToString(element) == value,
    );
    Task updateTask = _currentTask.copyWith(priority: priority);
    _updateTask(updateTask);
  }

  // Select a date
  // context: the context of the widget
  Future<DateTime> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _currentTask.deadline,
      firstDate: DatesUtils.firstDate,
      lastDate: DatesUtils.lastDate,
    );
    if (picked == null) return _currentTask.deadline!;
    Task updateTask = _currentTask.copyWith(deadline: picked);
    if (picked != _currentTask.deadline) {
      _updateTask(updateTask);
    }
    return picked;
  }

  // Format the date
  // date: the date to format
  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  void _addSubTask(String name) {
    SubTask task = SubTask(
      name: name,
      priority: _currentTask.priority,
      deadline: _currentTask.deadline!,
      isDone: false,
      projectId: _currentTask.projectId,
      parentId: _currentTask.id,
    );
    BlocProvider.of<TaskBloc>(context).add(AddSubTask(task));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: IntrinsicHeight(
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 16.0,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: TaskCheckbox(
                    task: _currentTask,
                    onChanged: (bool? value) {
                      Task updateTask = _currentTask.copyWith(isDone: value!);
                      _updateTask(updateTask);
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            semanticLabel: "Deadline"),
                        TextButton(
                          onPressed: () => _selectDate(context),
                          child: Text(_formatDate(_currentTask.deadline!)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.flag_outlined,
                            semanticLabel: "Priority"),
                        FilteringWidget(
                          onValueChanged: _updateFiltering,
                          initialValue:
                              TaskUtils.priorityToString(_currentTask.priority),
                          items: const ["Basse", "Moyenne", "Haute"],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 10, height: 8),
                Container(
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.line,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                SubTaskCheckbox(
                  onChanged: (bool? value) {
                    Task updateTask = _currentTask.copyWith(isDone: value!);
                    _updateTask(updateTask);
                  },
                ),
                Row(
                  children: [
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    const Icon(Icons.add),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Ajouter une sous-tache',
                          border: InputBorder.none,
                        ),
                        onSubmitted: (value) {
                          _addSubTask(value);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TaskCheckbox extends StatelessWidget {
  final Task task;
  final Function(bool?) onChanged;

  const TaskCheckbox({super.key, required this.task, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: task.isDone,
          onChanged: onChanged,
          shape: const CircleBorder(),
        ),
        Expanded(
          child: Text(
            task.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              decoration: task.isDone
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
          ),
        ),
      ],
    );
  }
}

class SubTaskCheckbox extends StatelessWidget {
  final Function(bool?) onChanged;
  final bool _value = false;

  const SubTaskCheckbox({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Transform.scale(
          scale: 0.8,
          child: Checkbox(
            value: _value,
            onChanged: onChanged,
          ),
        ),
        Expanded(
          child: Text(
            "task",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              decoration:
                  _value ? TextDecoration.lineThrough : TextDecoration.none,
            ),
          ),
        ),
      ],
    );
  }
}
