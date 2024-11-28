import '../../core/task_priority_enum.dart';

class Task {
  String title;
  TaskPriority priority;
  DateTime date;
  int numberSubtask; //surement devoir Changer ca
  bool isDone;

  Task(
      {required this.title,
      required this.priority,
      required this.date,
      required this.numberSubtask,
      required this.isDone});

  //toggle the task done or not
  void toggleDone() {
    isDone = !isDone;
  }
}
