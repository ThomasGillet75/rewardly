import 'package:flutter/material.dart';

import '../../core/Priority.dart';



class TaskCardWidget extends StatefulWidget {
  const TaskCardWidget(
      {super.key,
        required this.title,
        required this.date,
        required this.priority,
        required this.task});

  final String title;
  final DateTime date;
  final Priority priority;
  final int task;

  @override
  State<TaskCardWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskCardWidget> {
  bool _isChecked = false;

  MaterialColor _setColor(Priority priority) {
    switch (priority) {
      case Priority.low:
        return Colors.green;
      case Priority.medium:
        return Colors.amber;
      case Priority.high:
        return Colors.red;
    }
  }

  String _getDateFromDateTime(DateTime date) {
    const List<String> months = [
      "Janvier",
      "Fevrier",
      "Mars",
      "Avril",
      "Mai",
      "Juin",
      "Juillet",
      "Aout",
      "Septembre",
      "Octobre",
      "Novembre",
      "Decembre"
    ];

    return "${date.day} ${months[date.month - 1]}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.only(right: 14.0),
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: _setColor(widget.priority),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Checkbox(
            value: _isChecked,
            onChanged: (bool? value) {
              setState(() {
                _isChecked = value!;
              });
            },
            shape: const CircleBorder(),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  _getDateFromDateTime(widget.date),
                  style: const TextStyle(fontSize: 10.0),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Transform.translate(
                offset: const Offset(10.0, 0.0),
                child: Transform.scale(
                  scale: 0.8,
                  child: const Checkbox(
                    value: false,
                    onChanged: null,
                  ),
                ),
              ),
              SizedBox(
                width: 50, // Adjust the width as needed
                child: Text(
                  "0/${widget.task}",
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
