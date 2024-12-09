import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rewardly/Data/entity/task.dart';
import 'package:rewardly/core/task_priority_enum.dart';
import 'package:rewardly/presentation/widget/add_project_widget.dart';
import 'package:rewardly/presentation/widget/container_filtering_task_widget.dart';
import 'package:rewardly/presentation/widget/toggle_button_widget.dart';
import 'package:rewardly/presentation/widget/reward_card_widget.dart';
import 'package:rewardly/presentation/widget/project_car_widget.dart';

import '../../bloc/toggle_bloc.dart';
import '../widget/add_task_widget.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key, required this.title});

  final String title;

  @override
  State<HomePageScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomePageScreen> {
  List<Task> tasks = [
    Task(
        title: "Merge",
        priority: TaskPriority.medium,
        date: DateTime(2024, 11, 30),
        numberSubtask: 9,
        isDone: false),
    Task(
        title: "Faire android",
        priority: TaskPriority.high,
        date: DateTime(2024, 12, 01),
        numberSubtask: 3,
        isDone: false),
    Task(
        title: "Faire ios",
        priority: TaskPriority.low,
        date: DateTime(2024, 12, 5),
        numberSubtask: 1,
        isDone: false)
  ];

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
          const RewardCardWidget(
              title: "chocolat", taskDone: 6, taskTodo: 8),
          const ToggleButtonWidget(),
          BlocBuilder<ToggleBloc, ToggleState>(
            builder: (context, state) {
              if (state is ToggleInitial && state.isMesTachesSelected) {
                return ContainerFilteringTaskWidget(tasks: tasks);
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
