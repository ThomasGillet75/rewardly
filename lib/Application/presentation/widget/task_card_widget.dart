import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rewardly/Application/bloc/task/task_bloc.dart';
import 'package:rewardly/Core/task_priority_enum.dart';
import 'package:rewardly/Core/utils/date_utils.dart';
import 'package:rewardly/Data/models/task_entity.dart';

import '../../../core/color.dart';

class TaskCardWidget extends StatefulWidget {
  const TaskCardWidget({super.key, required this.task});
  final Task task;

  @override
  State<TaskCardWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskCardWidget> {
  // set the color of the border task card based on the priority
  final Map<TaskPriority, Color> _priorityColors = {
    TaskPriority.low: AppColors.reward_lowPriority,
    TaskPriority.medium: AppColors.mediumPriority,
    TaskPriority.high: AppColors.highPriority,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.only(right: 14.0),
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: _priorityColors[widget.task.priority]!,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Checkbox(
            value: widget.task.isDone,
            onChanged: (bool? value) {
              BlocProvider.of<TaskBloc>(context)
                  .add(UpdateTask(widget.task.copyWith(isDone: value!)));
            },
            shape: const CircleBorder(),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.task.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: widget.task.isDone
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                Text(
                  DatesUtils.getDateFromDateTime(widget.task.deadline!),
                  style: const TextStyle(fontSize: 10.0),
                ),
              ],
            ),
          ),
          if (widget.task.subTasks.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Transform.translate(
                  offset: const Offset(10.0, 0.0),
                  child: Transform.scale(
                    scale: 0.8,
                    child: const Checkbox(
                      value: false,
                      onChanged: null,
                    ),
                  ),
                ),
                SizedBox(
                  width: 50, // Adjust the width as needed
                  child: Text(
                    "${widget.task.calculateLeftTaskToDo()}/${widget.task.calculateTotalTaskToDo()}",
                    style: const TextStyle(
                      color: AppColors.font,
                    ),
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }
}
