import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rewardly/Core/color.dart';
import 'package:rewardly/Data/models/project_entity.dart';
import 'package:rewardly/Data/models/task_entity.dart';

class RewardCardWidget extends StatefulWidget {
  const RewardCardWidget({
    super.key,
    required this.project,
    required this.taskList,
    required this.onRewardSelected,
  });

  final Project project;
  final List<Task> taskList;
  final void Function(Project project) onRewardSelected;

  @override
  State<RewardCardWidget> createState() => _RewardCardWidgetState();
}

class _RewardCardWidgetState extends State<RewardCardWidget> {
  final int _marginOffset = 96;

  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  // calculate the percentage for the size of the bar
  double _calculatePercentage(int taskDone, int taskTodo) {
    double completionPercentage = taskTodo > 0 ? taskDone / taskTodo : 0.0;
    double containerWidth = MediaQuery.of(context).size.width - _marginOffset;
    return containerWidth * completionPercentage;
  }

  void _addNewReward() {
    widget.onRewardSelected(widget.project);
  }

  void _showSuccess(int taskTodo, int taskDone) {
    if (taskTodo == taskDone && taskTodo != 0) {
      Fluttertoast.showToast(
        msg: "Félicitations ! Vous avez terminé toutes les tâches ! 🎉",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      _confettiController.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    final int taskDone = widget.taskList.where((task) => task.isDone).length;
    final int taskTodo = widget.taskList.length;

    _showSuccess(taskTodo,taskDone);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      constraints: const BoxConstraints(
        minHeight: 100,
      ),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          Column(
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
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.only(
                        top: 32, left: 32, right: 32, bottom: 10),
                    height: 17,
                    width: _calculatePercentage(taskDone, taskTodo),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  Positioned(
                    top: 28,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        "$taskDone/$taskTodo",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (widget.project.reward != "") ...[
                Text(widget.project.reward,
                    style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ] else ...[
                ElevatedButton(
                  onPressed: _addNewReward,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 8),
                      Text("Ajouter une récompense"),
                    ],
                  ),
                ),
              ]
            ],
          ),
          if (taskTodo == taskDone && taskTodo != 0) ...[
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  colors: const [
                    Colors.blue,
                    Colors.green,
                    Colors.pink,
                    Colors.orange
                  ],
                  gravity: 0.1,
                  child: Container(),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
