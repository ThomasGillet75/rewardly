import 'package:flutter/material.dart';

import '../../core/Priority.dart';
import '../widget/task_card_widget.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key, required this.title});

  final String title;

  @override
  State<HomePageScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomePageScreen> {
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
            TaskCardWidget(
                title: "Merge",
                date: DateTime(10, 10, 10),
                priority: Priority.medium,
                task: 10),

            TaskCardWidget(
                title: "Faire android",
                date: DateTime(5, 7, 4),
                priority: Priority.high,
                task: 3),
            TaskCardWidget(
                title: "Faire ios",
                date: DateTime(2, 12, 2),
                priority: Priority.low,
                task: 1),
          ]),
      floatingActionButton: FloatingActionButton(
          onPressed: _action, child: const Icon(Icons.add)),
    );
  }
}

class TaskWidget {
}
