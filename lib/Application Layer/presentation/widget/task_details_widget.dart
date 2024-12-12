import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rewardly/Application%20Layer/bloc/task/task_bloc.dart';
import 'package:rewardly/Application%20Layer/presentation/widget/filtering_widget.dart';
import 'package:rewardly/Data/models/task_entity.dart';
import 'package:rewardly/core/task_priority_enum.dart';
import 'package:rewardly/core/utils/date_utils.dart';
import 'package:rewardly/core/utils/task_utils.dart';

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
    if(picked == null) return _currentTask.deadline!;
    Task updateTask = _currentTask.copyWith(deadline: picked);
    if (picked != _currentTask.deadline) {
      _updateTask(updateTask);
    }
    return picked;
  }

  // Format the date
  // date: the date to format
  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: IntrinsicHeight(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
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
              // Important pour limiter la taille verticale au contenu
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
                          child: Text(formatDate(_currentTask.deadline!)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.flag_outlined,
                            semanticLabel: "Priority"),
                        FilteringWidget(
                          onValueChanged: _updateFiltering,
                          initialValue: TaskUtils.priorityToString(_currentTask.priority),
                          items: const ["Low", "Medium", "High"],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                const SizedBox(height: 16),
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
              decoration: task.isDone ? TextDecoration.lineThrough : TextDecoration.none,
            ),
          ),
        ),
      ],
    );
  }
}
