import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rewardly/Application/bloc/priority_select/priority_select_bloc.dart';
import 'package:rewardly/Core/color.dart';
import 'package:rewardly/Core/task_priority_enum.dart';
import 'package:rewardly/Core/utils/task_utils.dart';

/*
  Widget to select the priority of a task
*/
class PrioritySelectWidget extends StatefulWidget {
  PrioritySelectWidget({super.key});

  TaskPriority? priorityController;

  @override
  State<PrioritySelectWidget> createState() => _PrioritySelectWidgetState();
}

/*
  State of the PrioritySelectWidget
*/
class _PrioritySelectWidgetState extends State<PrioritySelectWidget> {
  // List of priorities
  final List<String> _priorities = [
    TaskUtils.priorityToString(TaskPriority.low),
    TaskUtils.priorityToString(TaskPriority.medium),
    TaskUtils.priorityToString(TaskPriority.high)
  ];

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
      child: BlocBuilder<PrioritySelectBloc, PrioritySelectState>(
        builder: (context, state) {
          // Récupération de la priorité sélectionnée
          String? selectedPriority = TaskUtils.priorityToString(
              (state as PrioritySelectInitial).selectedPriority);

          return DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _priorities.contains(selectedPriority)
                  ? selectedPriority
                  : null,
              // Définit la valeur sélectionnée ou null si invalide
              hint: const Text(
                "Priorité",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.font,
                ),
              ),
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, size: 16),
              items: _priorities.map((priority) {
                return DropdownMenuItem(
                  value: priority,
                  child: Text(
                    priority.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              }).toList(),
              onChanged: (value) async {
                TaskPriority taskPriority =
                    await TaskUtils.stringToPriority(value!);
                context.read<PrioritySelectBloc>().add(
                      PrioritySelectSwitch(value: taskPriority),
                    );
              },
            ),
          );
        },
      ),
    );
  }
}
