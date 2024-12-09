import 'package:flutter/material.dart';

class RewardCardWidget extends StatefulWidget {
  const RewardCardWidget(
      {super.key,
      required this.title,
      required this.taskTodo,
      required this.taskDone});

  final String title;
  final int taskTodo;
  final int taskDone;

  @override
  State<RewardCardWidget> createState() => _RewardCardWidgetState();
}

class _RewardCardWidgetState extends State<RewardCardWidget> {
  final int _marginOffset = 96;

  // calculate the percentage for the size of the bar
  double calculatePercentage() {
    double completionPercentage =
        widget.taskTodo > 0 ? widget.taskDone / widget.taskTodo : 0.0;
    double containerWidth = MediaQuery.of(context).size.width - _marginOffset;
    return containerWidth * completionPercentage;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(
                    top: 32, left: 32, right: 32, bottom: 10),
                height: 17,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.green,
                    width: 2,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                    top: 32, left: 32, right: 32, bottom: 10),
                height: 17,
                width: calculatePercentage(),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              Positioned(
                top: 28,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    "${widget.taskDone}/${widget.taskTodo}",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          Text(widget.title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
