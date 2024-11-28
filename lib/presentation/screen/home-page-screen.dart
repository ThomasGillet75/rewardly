import 'package:flutter/material.dart';
import 'package:rewardly/Data/entity/task.dart';

import '../../core/task_priority_enum.dart';
import '../widget/task_card_widget.dart';

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
        date: DateTime(10, 10, 10),
        numberSubtask: 10,
        isDone: false),
    Task(
        title: "Faire android",
        priority: TaskPriority.high,
        date: DateTime(5, 7, 4),
        numberSubtask: 3,
        isDone: false),
    Task(
        title: "Faire ios",
        priority: TaskPriority.low,
        date: DateTime(2, 12, 2),
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
            TaskCardWidget(task: tasks[0]),
            TaskCardWidget(task: tasks[1]),
            TaskCardWidget(task: tasks[2]),
          ]),
      floatingActionButton: FloatingActionButton(
          onPressed: _action, child: const Icon(Icons.add)),
    );
  }
}

class TaskWidget {}
