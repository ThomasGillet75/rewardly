import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rewardly/Application/bloc/task/task_bloc.dart';
import 'package:rewardly/Application/presentation/widget/add_task_widget.dart';
import 'package:rewardly/Application/presentation/widget/container_filtering_task_widget.dart';
import 'package:rewardly/Application/presentation/widget/reward_card_widget.dart';
import 'package:rewardly/Application/presentation/widget/task_details_widget.dart';
import 'package:rewardly/Data/models/project_entity.dart';
import 'package:rewardly/Data/models/task_entity.dart';

class ProjectPageScreen extends StatefulWidget {
  const ProjectPageScreen({super.key, required this.project});

  final Project project;

  @override
  State<ProjectPageScreen> createState() => _ProjectPageScreenState();
}

class _ProjectPageScreenState extends State<ProjectPageScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(GetTasksByProjectId(widget.project.id));
  }

  void _showTaskDetails(Task task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) => TaskDetailsWidget(task: task),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.project.name),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: [
          RewardCardWidget(title: widget.project.reward, taskDone: 6, taskTodo: 8),
          BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              return ContainerFilteringTaskWidget(
                tasks: state.tasks,
                onTaskSelected: _showTaskDetails,
                selectedFilter: "Tout",
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            builder: (context) => const AddTaskWidget(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
