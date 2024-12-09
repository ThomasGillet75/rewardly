import 'package:rewardly/core/task_priority_enum.dart';

class TaskUtils{

  //convert a string to a TaskPriority
  //priority: the priority to convert to string
  static String priorityToString(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return "Low";
      case TaskPriority.medium:
        return "Medium";
      case TaskPriority.high:
        return "High";
    }
  }
}