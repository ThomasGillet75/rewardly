import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rewardly/Application/bloc/task/task_bloc.dart';
import 'package:rewardly/Data/models/project_entity.dart';
import 'package:rewardly/Data/models/user_entity.dart';
import 'package:rewardly/core/color.dart';

class ProjectCarWidget extends StatefulWidget {
  const ProjectCarWidget({super.key, required this.project, required this.users});

  final Project project;
  final Map<String, List<Users>> users;

  @override
  State<ProjectCarWidget> createState() => _ProjectCardWidgetState();
}

class _ProjectCardWidgetState extends State<ProjectCarWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<TaskBloc>().add(Clear());
        Navigator.pushNamed(
          context,
          '/projectPage',
          arguments: {
            'project': widget.project,
            'users': widget.users,
          },
        );
      },
      child: Container(
        width: 200,
        height: 50,
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.secondary,
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.project.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}