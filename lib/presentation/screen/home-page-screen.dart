import 'package:flutter/material.dart';
import 'package:rewardly/Data/entity/task.dart';
import 'package:rewardly/core/task_priority_enum.dart';
import 'package:rewardly/presentation/widget/container_filtering_task_widget.dart';
import 'package:rewardly/presentation/widget/reward_card_widget.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key, required this.title});
  //title of the screen
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

  //action random
  void _action() {
    print("something");
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
            const RewardCardWidget(title: "chocolat",taskDone: 6, taskTodo: 8),
            ContainerFilteringTaskWidget(tasks: tasks),
          ]),
      floatingActionButton: FloatingActionButton(
          onPressed: _action, child: const Icon(Icons.add)),
    );
  }
}

class TaskWidget {}
