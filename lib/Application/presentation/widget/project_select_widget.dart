import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/color.dart';
import '../../bloc/project/project_bloc.dart';
import '../../bloc/project_select/project_select_bloc.dart';

/*
  Widget to select the project of a task
*/
class ProjectSelectWidget extends StatefulWidget {
  ProjectSelectWidget({Key? key, this.projectController}) : super(key: key);
  String? projectController;

  @override
  State<ProjectSelectWidget> createState() => _ProjectSelectWidgetState();
}

/*
  State of the ProjectSelectWidget
*/
class _ProjectSelectWidgetState extends State<ProjectSelectWidget> {
  final List<String> _projects = ['Ecole', 'Maison', 'IOT'];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectBloc, ProjectState>(
        builder: (context, state) {
          Map<String, String> _projects = {};
          state.projects.forEach((project) {
            _projects[project.name] = project.id;
          });
          return Expanded(
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: AppColors.backgroundTextInput,
                  border: Border.all(
                    color: AppColors.borderTextInput,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _projects[widget.projectController],
                    hint: const Text(
                      "Projet",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.font),
                    ),
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down, size: 16),
                    items: _projects.entries.map((entry) {
                      return DropdownMenuItem<String>(
                        value: entry.value,
                        child: Text(
                          entry.key,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        context.read<ProjectSelectBloc>().add(ProjectSelectSwitch(value: value!));
                      });
                    },
                  ),
                ),
              ));
        });
  }
}
