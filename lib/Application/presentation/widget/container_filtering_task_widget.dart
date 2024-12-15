import 'package:flutter/material.dart';
import 'package:rewardly/Application/presentation/widget/filtering_widget.dart';
import 'package:rewardly/Application/presentation/widget/task_card_widget.dart';
import 'package:rewardly/Core/utils/task_utils.dart';
import 'package:rewardly/Data/models/task_entity.dart';

class ContainerFilteringTaskWidget extends StatefulWidget {
  const ContainerFilteringTaskWidget(
      {super.key, required this.tasks, required this.onTaskSelected, this.selectedFilter = "Date"});

  final String selectedFilter;
  final List<Task> tasks;
  final Function(Task) onTaskSelected;

  @override
  State<ContainerFilteringTaskWidget> createState() =>
      _ContainerFilteringTaskWidgetState();
}

class _ContainerFilteringTaskWidgetState
    extends State<ContainerFilteringTaskWidget> {
  late String _selectedFilter;
  final Map<String, List<String>> _filterLabels = {
    "Date": ["Aujourd'hui", "Demain", "Cette Semaine"],
    "Priorité": ["Haute", "Moyenne", "Basse"],
    "Tout": [""]
  };
  List<String> get _values => _filterLabels[_selectedFilter] ?? ["Inconnu"];

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.selectedFilter;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text( _filterLabels[_selectedFilter]?.first ?? "", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
            FilteringWidget(
              onValueChanged: _updateFiltering,
              initialValue: _selectedFilter,
              items: _filterLabels.keys.toList(),
            ),
          ],
        ),
        TaskListSection(
          label: "",
          tasks: _filterTasks(_values.first),
          onTaskSelected: widget.onTaskSelected,
        ),
        ..._values.skip(1).map((label) {
          return TaskListSection(
            label: label,
            tasks: _filterTasks(label),
            onTaskSelected: widget.onTaskSelected,
          );
        }),
        ...[
          if (TaskUtils.filterByDone(widget.tasks).isNotEmpty)
            TaskListSection(
              label: "Finit",
              tasks: TaskUtils.filterByDone(widget.tasks),
              onTaskSelected: widget.onTaskSelected,
            ),
        ]
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

  // Filter the task
  // @param label the label of the filter
  // @return the list of task filtered
  List<Task> _filterTasks(String label) {
    switch (_selectedFilter) {
      case "Date":
        return  TaskUtils.filterByNotDone(TaskUtils.filterByDate(label, widget.tasks));
      case "Priorité":
        return TaskUtils.filterByNotDone(TaskUtils.filterByPriority(label, widget.tasks));
      case "Tout":
        return TaskUtils.filterByNotDone(widget.tasks);
      default:
        return [];
    }
  }
}

class TaskListSection extends StatelessWidget {
  const TaskListSection({
    super.key,
    required this.label,
    required this.tasks,
    required this.onTaskSelected,
  });

  final String label;
  final List<Task> tasks;
  final Function(Task) onTaskSelected;

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty && label != "") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          const Text("Aucune tâche", style: TextStyle(fontSize: 16)),
        ],
      );
    }
    else if (tasks.isEmpty) {
      return const Text("Aucune tâche", style: TextStyle(fontSize: 16));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(label != "")
          Text(label, style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20)),
        Column(
          children: tasks.map((task) {
            return GestureDetector(
              onTap: () => onTaskSelected(task),
              child: TaskCardWidget(task: task),
            );
          }).toList(),
        ),
      ],
    );
  }
}
