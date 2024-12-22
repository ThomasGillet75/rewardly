import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rewardly/Application/bloc/project/project_bloc.dart';
import 'package:rewardly/Application/bloc/task/task_bloc.dart';
import 'package:rewardly/Application/presentation/widget/add_reward_widget.dart';
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

  void _showRewardDetails(Project project) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) => AddRewardWidget(project: project),
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
          BlocBuilder<ProjectBloc, ProjectState>(
            builder: (context, projectState) {
              if (projectState is ProjectLoaded) {
                final updatedProject = projectState.projects.firstWhere(
                  (proj) => proj.id == widget.project.id,
                  orElse: () => widget.project,
                );

                return Column(
                  children: [
                    RewardCardWidget(
                      project: updatedProject,
                      taskList:
                          (context.read<TaskBloc>().state as TaskLoaded).tasks,
                      onRewardSelected: _showRewardDetails,
                    ),
                    BlocBuilder<TaskBloc, TaskState>(
                      builder: (context, taskState) {
                        if (taskState is TaskLoaded) {
                          return ContainerFilteringTaskWidget(
                            tasks: taskState.tasks,
                            onTaskSelected: _showTaskDetails,
                            selectedFilter: "Tout",
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          )
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
