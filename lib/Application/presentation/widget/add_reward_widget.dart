import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rewardly/Application/bloc/project/project_bloc.dart';
import 'package:rewardly/Core/color.dart';
import 'package:rewardly/Data/models/project_entity.dart';
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
      BlocProvider.of<ProjectBloc>(context).add(AddReward(widget.project));
    } catch (e) {
      print(e);
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
            decoration: InputDecoration(
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
