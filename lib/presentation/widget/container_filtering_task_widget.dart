import 'package:flutter/material.dart';
import 'package:rewardly/Data/entity/task.dart';
import 'package:rewardly/core/task_priority_enum.dart';
import 'package:rewardly/presentation/widget/filtering_widget.dart';
import 'package:rewardly/presentation/widget/task_card_widget.dart';
import 'package:rewardly/core/utils/date_utils.dart';

class ContainerFilteringTaskWidget extends StatefulWidget {
  const ContainerFilteringTaskWidget({super.key, required this.tasks});

  final List<Task> tasks;

  @override
  State<ContainerFilteringTaskWidget> createState() =>
      _ContainerFilteringTaskWidgetState();
}

class _ContainerFilteringTaskWidgetState
    extends State<ContainerFilteringTaskWidget> {
  String _selectedFilter = "Date";
  final Map<String, List<String>> _filterLabels = {
    "Date": ["Aujourd'hui", "Demain", "Cette Semaine"],
    "Priorité": ["Haute", "Moyenne", "Basse"],
  };

  List<String> get _values => _filterLabels[_selectedFilter] ?? ["Inconnu"];

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(_values[0], style: textStyle)),
            FilteringWidget(
              onValueChanged: _updateFiltering,
              initialValue: _selectedFilter,
              items: _filterLabels.keys.toList(),
            ),
          ],
        ),
        _buildTaskList(_values[0]),
        Text(_values[1], style: textStyle),
        _buildTaskList(_values[1]),
        Text(_values[2], style: textStyle),
        _buildTaskList(_values[2]),
      ],
    );
  }

  // Update the filtering value
  // @param value the new value to set
  void _updateFiltering(String? value) {
    setState(() {
      _selectedFilter = value ?? "Date";
    });
  }

  // Build the task list
  // @param label the label of the filter
  // @return the widget to display
  Widget _buildTaskList(String label) {
    final filteredTasks = _filterTasks(label);

    if (filteredTasks.isEmpty) {
      return const Text("Aucune tâche");
    }

    return Column(
      children:
          filteredTasks.map((task) => TaskCardWidget(task: task)).toList(),
    );
  }

  // Filter the task
  // @param label the label of the filter
  // @return the list of task filtered
  List<Task> _filterTasks(String label) {
    List<Task> task = [];
    switch (_selectedFilter) {
      case "Date":
        return taskFilteredByDate(label, task);
      case "Priorité":
        return taskFilteredByPriority(label, task);
    }
    return [];
  }


  // Filter the task by priority
  // @param label the label of the filter
  // @param task the list of task to filter
  // @return the list of task filtered
  List<Task> taskFilteredByPriority(String label, List<Task> task) {
    if (label == "Haute") {
      task = widget.tasks
          .where((task) => task.priority == TaskPriority.high)
          .toList();
    } else if (label == "Moyenne") {
      task = widget.tasks
          .where((task) => task.priority == TaskPriority.medium)
          .toList();
    } else if (label == "Basse") {
      task = widget.tasks
          .where((task) => task.priority == TaskPriority.low)
          .toList();
    }
    return task;
  }

  // Filter the task by date
  // @param label the label of the filter
  // @param task the list of task to filter
  // @return the list of task filtered
  List<Task> taskFilteredByDate(String label, List<Task> task) {
    if (label == "Aujourd'hui") {
      task = widget.tasks
          .where((task) => DatesUtils.isSameDay(task.date, DateTime.now()))
          .toList();
    } else if (label == "Demain") {
      task = widget.tasks
          .where((task) => DatesUtils.isTomorrow(task.date, DateTime.now()))
          .toList();
    } else if (label == "Cette Semaine") {
      task = widget.tasks
          .where((task) =>
              DatesUtils.isSameWeek(task.date, DateTime.now()) &&
              !DatesUtils.isTomorrow(task.date, DateTime.now()) &&
              !DatesUtils.isSameDay(task.date, DateTime.now()))
          .toList();
    }
    return task;
  }
}
