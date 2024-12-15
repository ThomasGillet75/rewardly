import 'package:rewardly/Core/task_priority_enum.dart';
import 'package:rewardly/Core/utils/date_utils.dart';
import 'package:rewardly/Data/models/task_entity.dart';

class TaskUtils {
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


  // Filter the task by priority
  // @param label the label of the filter
  // @param task the list of task to filter
  // @return the list of task filtered
  static List<Task> filterByPriority(String label, List<Task> tasks) {
    switch (label) {
      case "Haute":
        return tasks
            .where((task) => task.priority == TaskPriority.high)
            .toList();
      case "Moyenne":
        return tasks
            .where((task) => task.priority == TaskPriority.medium)
            .toList();
      case "Basse":
        return tasks
            .where((task) => task.priority == TaskPriority.low)
            .toList();
      default:
        return [];
    }
  }

  // Filter the task by date
  // @param label the label of the filter
  // @param task the list of task to filter
  // @return the list of task filtered
  static List<Task> filterByDate(String label, List<Task> tasks) {
    switch (label) {
      case "Aujourd'hui":
        return tasks
            .where(
                (task) => DatesUtils.isSameDay(task.deadline!, DateTime.now()))
            .toList();
      case "Demain":
        return tasks
            .where(
                (task) => DatesUtils.isTomorrow(task.deadline!, DateTime.now()))
            .toList();
      case "Cette Semaine":
        return tasks
            .where((task) =>
                DatesUtils.isSameWeek(task.deadline!, DateTime.now()) &&
                !DatesUtils.isTomorrow(task.deadline!, DateTime.now()) &&
                !DatesUtils.isSameDay(task.deadline!, DateTime.now()))
            .toList();
      default:
        return [];
    }
  }

  static List<Task> filterByNotDone(List<Task> tasks) {
    return tasks.where((task) => !task.isDone).toList();
  }

  static List<Task> filterByDone(List<Task> tasks) {
    return tasks.where((task) => task.isDone).toList();
  }
}
