import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rewardly/Application/bloc/project/project_bloc.dart';
import 'package:rewardly/Application/bloc/task/task_bloc.dart';
import 'package:rewardly/Application/presentation/widget/add_reward_widget.dart';
import 'package:rewardly/Application/presentation/widget/add_task_and_project_widget/add_task_widget.dart';
import 'package:rewardly/Application/presentation/widget/container_filtering_task_widget.dart';
import 'package:rewardly/Application/presentation/widget/friend_widget/icon_add_friend_to_project_widget.dart';
import 'package:rewardly/Application/presentation/widget/reward_card_widget.dart';
import 'package:rewardly/Application/presentation/widget/task_details_widget.dart';
import 'package:rewardly/Data/models/project_entity.dart';
import 'package:rewardly/Data/models/task_entity.dart';
import 'package:rewardly/Data/models/user_entity.dart';

class ProjectPageScreen extends StatefulWidget {
  const ProjectPageScreen(
      {super.key, required this.project, required this.user});

  final Project project;
  final Map<String, List<Users>> user;

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
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: Text(widget.project.name),
        actions: [
          IconAddFriendButtonWidget(
              users: widget.user, project: widget.project),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: [
          BlocBuilder<TaskBloc, TaskState>(
            builder: (context, taskState) {
              if (taskState is TaskLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (taskState is TaskLoaded &&
                  taskState.isProjectContext &&
                  taskState.projectId == widget.project.id) {
                return BlocBuilder<ProjectBloc, ProjectState>(
                  builder: (context, projectState) {
                    if (projectState is ProjectLoaded) {
                      final updatedProject = projectState.projects.firstWhere(
                            (p) => p.id == widget.project.id,
                        orElse: () => widget.project,
                      );
                      return Column(
                        children: [
                          RewardCardWidget(
                            project: updatedProject,
                            taskList: taskState.tasks,
                            onRewardSelected: _showRewardDetails,
                          ),
                          ContainerFilteringTaskWidget(
                            tasks: taskState.tasks,
                            onTaskSelected: _showTaskDetails,
                            selectedFilter: "Tout",
                          ),
                        ],
                      );
                    } else if (projectState is ProjectFailure) {
                      return Center(
                        child: Text('Failed to load projects: ${projectState
                            .error}'),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                );
              } else if (taskState is TaskFailure) {
              return Center(
              child: Text('Failed to load tasks: ${taskState.error}'));
              } else {
              return const Center(child: CircularProgressIndicator());
              }
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
            builder: (context) => AddTaskWidget(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
