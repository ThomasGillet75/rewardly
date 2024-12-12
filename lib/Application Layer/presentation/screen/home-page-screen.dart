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
import 'package:rewardly/core/task_priority_enum.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key, required this.title});

  final String title;

  @override
  State<HomePageScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomePageScreen> {
  List<Task> tasks = [
    Task(
        name: "Merge",
        priority: TaskPriority.medium,
        deadline: DateTime(2024, 11, 30),
        numberSubtask: 9,
        isDone: false),
    Task(
        name: "Faire android",
        priority: TaskPriority.high,
        deadline: DateTime(2024, 12, 01),
        numberSubtask: 3,
        isDone: false),
    Task(
      name: "Faire ios",
      priority: TaskPriority.low,
      deadline: DateTime(2024, 12, 5),
      numberSubtask: 1,
      isDone: false,
    )
  ];

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
    context.read<TaskBloc>().add(AddTasks(tasks));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
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
                    tasks = state.tasks;
                    return ContainerFilteringTaskWidget(
                      tasks: tasks,
                      onTaskSelected: _showTaskDetails,
                    );
                  },
                );
              }else{
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
