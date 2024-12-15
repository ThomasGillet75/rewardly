import 'package:rewardly/Core/task_priority_enum.dart';

class TaskUtils{

  //convert a string to a TaskPriority
  //priority: the priority to convert to string
  static String priorityToString(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return "Basse";
      case TaskPriority.medium:
        return "Moyenne";
      case TaskPriority.high:
        return "Haute";
    }
  }
}