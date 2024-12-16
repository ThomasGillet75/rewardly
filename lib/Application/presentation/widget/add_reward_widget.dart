import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rewardly/Application/bloc/project/project_bloc.dart';
import 'package:rewardly/Application/bloc/task/task_bloc.dart';
import 'package:rewardly/Application/presentation/widget/filtering_widget.dart';
import 'package:rewardly/Core/task_priority_enum.dart';
import 'package:rewardly/Core/utils/date_utils.dart';
import 'package:rewardly/Core/utils/task_utils.dart';
import 'package:rewardly/Data/models/project_entity.dart';
import 'package:rewardly/Data/models/sub_task_entity.dart';
import 'package:rewardly/Data/models/task_entity.dart';

import '../../../Core/color.dart';

class AddRewardWidget extends StatefulWidget {
  const AddRewardWidget({super.key, required this.project});
  final Project project;

  @override
  State<AddRewardWidget> createState() => _AddRewardWidgetState();
}

class _AddRewardWidgetState extends State<AddRewardWidget> {
  final TextEditingController _textController = TextEditingController();

  void _addSubTask(String name) async {
    widget.project.reward = name;
    try {
      BlocProvider.of<ProjectBloc>(context).add(AddReward( widget.project));
      print('Reward added successfully');
    } catch (e) {
      print('Failed to add reward: $e');
    }
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: IntrinsicHeight(
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: _buildAddTaskField("Ajouter une récompense"),
        ),
      ),
    );
  }

  Widget _buildAddTaskField(String name) {
    return Row(

      children: [
        const Padding(padding: EdgeInsets.only(left: 10)),
        const Icon(Icons.add),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: _textController,
            decoration:  InputDecoration(
              hintText: name,
              border: InputBorder.none,
            ),
            onSubmitted: (value) => _addSubTask(value),
          ),
        ),
      ],
    );
  }
}

