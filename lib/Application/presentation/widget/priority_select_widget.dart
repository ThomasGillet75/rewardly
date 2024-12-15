import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rewardly/Core/task_priority_enum.dart';
import 'package:rewardly/Core/utils/task_utils.dart';

import '../../../core/color.dart';

/*
  Widget to select the priority of a task
*/
class PrioritySelectWidget extends StatefulWidget{
  const PrioritySelectWidget ({Key? key}) : super(key: key);

  @override
  State<PrioritySelectWidget> createState() => _PrioritySelectWidgetState();
}

/*
  State of the PrioritySelectWidget
*/
class _PrioritySelectWidgetState extends State<PrioritySelectWidget>{
  String? _selectedPriority;
  // List of priorities
  final List<String> _priorities = [TaskUtils.priorityToString(TaskPriority.low), TaskUtils.priorityToString(TaskPriority.medium), TaskUtils.priorityToString(TaskPriority.high)];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: AppColors.backgroundTextInput,
        border: Border.all(
          color: AppColors.borderTextInput,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedPriority,
          hint: const Text(
            "Priorité",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.font),
          ),
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, size: 16),
          items: _priorities.map((priority) {
            return DropdownMenuItem(
              value: priority.toString(),
              child: Text(
                priority.toString().split('.').last,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedPriority = value;
            });
          },
        ),
      ),
    );
  }
}