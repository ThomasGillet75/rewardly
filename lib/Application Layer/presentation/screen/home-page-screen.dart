import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rewardly/Application%20Layer/bloc/task/task_bloc.dart';
import 'package:rewardly/Application%20Layer/bloc/toggle/toggle_bloc.dart';
import 'package:rewardly/Application%20Layer/presentation/widget/add_project_widget.dart';
import 'package:rewardly/Application%20Layer/presentation/widget/add_task_widget.dart';
import 'package:rewardly/Application%20Layer/presentation/widget/container_filtering_task_widget.dart';
import 'package:rewardly/Application%20Layer/presentation/widget/project_card_widget.dart';
import 'package:rewardly/Application%20Layer/presentation/widget/reward_card_widget.dart';
import 'package:rewardly/Application%20Layer/presentation/widget/task_details_widget.dart';
import 'package:rewardly/Application%20Layer/presentation/widget/toggle_button_widget.dart';
import 'package:rewardly/Data/models/task_entity.dart';

import '../widget/Icon_friends_button_widget.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key, required this.title});

  final String title;

  @override
  State<HomePageScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomePageScreen> {
  // Show the task details
  // task: the task details to show
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
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(GetTasks());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: Text(widget.title),
        //add icon
        actions: const [

          IconFriendButtonWidget(),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: [
          const RewardCardWidget(title: "chocolat", taskDone: 6, taskTodo: 8),
          const ToggleButtonWidget(),
          BlocBuilder<ToggleBloc, ToggleState>(
            builder: (context, state) {
              if ((state as ToggleInitial).isMesTachesSelected) {
                return BlocBuilder<TaskBloc, TaskState>(
                  builder: (context, state) {
                    return ContainerFilteringTaskWidget(
                      tasks: state.tasks,
                      onTaskSelected: _showTaskDetails,
                    );
                  },
                );
              } else {
                return const ProjectCarWidget(projectName: "Réussir son année");
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
            builder: (context) {
              return BlocBuilder<ToggleBloc, ToggleState>(
                builder: (context, state) {
                  if (state is ToggleInitial && state.isMesTachesSelected) {
                    return const AddTaskWidget();
                  } else {
                    return const AddProjectWidget();
                  }
                },
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
