import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rewardly/Application/bloc/task/task_bloc.dart';
import 'package:rewardly/Application/presentation/widget/filtering_widget.dart';
import 'package:rewardly/Core/task_priority_enum.dart';
import 'package:rewardly/Core/utils/date_utils.dart';
import 'package:rewardly/Core/utils/task_utils.dart';
import 'package:rewardly/Data/models/sub_task_entity.dart';
import 'package:rewardly/Data/models/task_entity.dart';

import '../../../Core/color.dart';

class TaskDetailsWidget extends StatefulWidget {
  const TaskDetailsWidget({super.key, required this.task});

  final Task task;

  @override
  State<TaskDetailsWidget> createState() => _TaskDetailsWidgetState();
}

class _TaskDetailsWidgetState extends State<TaskDetailsWidget> {
  late Task _currentTask;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentTask = widget.task;
  }

  void _updateTask(Task updatedTask) {
    BlocProvider.of<TaskBloc>(context).add(UpdateTask(updatedTask));
    setState(() => _currentTask = updatedTask);
  }

  void _updateSubTask(SubTask updatedSubTask) {
    BlocProvider.of<TaskBloc>(context).add(UpdateSubTask(updatedSubTask));
    setState(() {
      final index = _currentTask.subTasks.indexWhere((e) => e.id == updatedSubTask.id);
      _currentTask.subTasks[index] = updatedSubTask;
    });
  }

  void _addSubTask(String name) {
    final newSubTask = SubTask(
      name: name,
      priority: _currentTask.priority,
      deadline: _currentTask.deadline!,
      isDone: false,
      projectId: _currentTask.projectId,
      parentId: _currentTask.id,
    );

    BlocProvider.of<TaskBloc>(context).add(AddSubTask(newSubTask));
    setState(() => _currentTask.subTasks.add(newSubTask));
    _textController.clear();
  }

  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _currentTask.deadline,
      firstDate: DatesUtils.firstDate,
      lastDate: DatesUtils.lastDate,
    );
    if (pickedDate != null && pickedDate != _currentTask.deadline) {
      _updateTask(_currentTask.copyWith(deadline: pickedDate));
    }
  }

  void _changePriority(String? value) {
    if (value == null) return;
    final priority = TaskPriority.values.firstWhere(
          (enumPriority) => TaskUtils.priorityToString(enumPriority) == value,
    );
    _updateTask(_currentTask.copyWith(priority: priority));
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
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ajouté pour limiter la taille du Column
            children: [
              TaskCheckbox(
                task: _currentTask,
                onChanged: (value) =>
                    _updateTask(_currentTask.copyWith(isDone: value!)),
              ),
              _buildDetailsRow(),
              const Divider(thickness: 2, color: AppColors.line),
              _buildSubTasks(),
              _buildAddSubTaskField(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildDatePicker(),
        _buildPrioritySelector(),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Row(
      children: [
        const Icon(Icons.access_time, semanticLabel: "Deadline"),
        TextButton(
          onPressed: _pickDate,
          child: Text("${_currentTask.deadline?.day}/${_currentTask.deadline?.month}/${_currentTask.deadline?.year}"),
        ),
      ],
    );
  }

  Widget _buildPrioritySelector() {
    return Row(
      children: [
        const Icon(Icons.flag_outlined, semanticLabel: "Priority"),
        FilteringWidget(
          onValueChanged: _changePriority,
          initialValue: TaskUtils.priorityToString(_currentTask.priority),
          items: const ["Basse", "Moyenne", "Haute"],
        ),
      ],
    );
  }

  Widget _buildSubTasks() {
    if (_currentTask.subTasks.isEmpty) {
      return const SizedBox.shrink();
    }
    if (_currentTask.subTasks.length > 5) {
      return SizedBox(
        height: 250,
        child: ListView.builder(
          itemCount: _currentTask.subTasks.length,
          itemBuilder: (context, index) {
            return SubTaskCheckbox(
              subTask: _currentTask.subTasks[index],
              onChanged: (value) =>
                  _updateSubTask(_currentTask.subTasks[index].copyingWith(isDone: value!)),
            );
          },
        ),
      );
    }

    return Column(
      children: _currentTask.subTasks.map((subTask) {
        return SubTaskCheckbox(
          subTask: subTask,
          onChanged: (value) =>
              _updateSubTask(subTask.copyingWith(isDone: value!)),
        );
      }).toList(),
    );
  }


  Widget _buildAddSubTaskField() {
    return Row(

      children: [
        const Padding(padding: EdgeInsets.only(left: 10)),
        const Icon(Icons.add),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: _textController,
            decoration: const InputDecoration(
              hintText: 'Ajouter une sous-tâche',
              border: InputBorder.none,
            ),
            onSubmitted: (value) => _addSubTask(value),
          ),
        ),
      ],
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
  final SubTask subTask;

  const SubTaskCheckbox({super.key, required this.onChanged, required this.subTask});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Transform.scale(
          scale: 0.8,
          child: Checkbox(
            value: subTask.isDone,
            onChanged: onChanged,
          ),
        ),
        Expanded(
          child: Text(
            subTask.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              decoration: subTask.isDone
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
          ),
        ),
      ],
    );
  }
}
