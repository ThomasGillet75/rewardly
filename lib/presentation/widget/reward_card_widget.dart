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
  double getPourcentage() {
    double completionPercentage =
        widget.taskTodo > 0 ? widget.taskDone / widget.taskTodo : 0.0;
    // Récupère la largeur de l'écran et soustrait les marges
    double containerWidth =
        MediaQuery.of(context).size.width - 96; // 32 + 32 de marge
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
                width: getPourcentage(),
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
                      color: Colors.white
                    ),
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
