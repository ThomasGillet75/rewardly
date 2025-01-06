import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rewardly/Application/bloc/project/project_bloc.dart';
import 'package:rewardly/Application/bloc/project_select/project_select_bloc.dart';
import 'package:rewardly/Core/color.dart';

/*
  Widget to select the project of a task
*/
class ProjectSelectWidget extends StatefulWidget {
  ProjectSelectWidget({super.key});

  String? projectController;

  @override
  State<ProjectSelectWidget> createState() => _ProjectSelectWidgetState();
}

/*
  State of the ProjectSelectWidget
*/
class _ProjectSelectWidgetState extends State<ProjectSelectWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectBloc, ProjectState>(
      builder: (context, projectState) {
        if (projectState is ProjectLoaded) {
          // Populate projects map
          Map<String, String> projects = {
            for (var project in projectState.projects) project.name: project.id,
          };

          return BlocBuilder<ProjectSelectBloc, ProjectSelectState>(
            builder: (context, projectSelectState) {
              String? selectedProjectId =
                  projectSelectState is ProjectSelectInitial
                      ? projectSelectState.selectedProject
                      : null;

              String? selectedProjectName = (selectedProjectId != null &&
                      projects.containsValue(selectedProjectId))
                  ? projects.entries
                      .firstWhere(
                        (entry) => entry.value == selectedProjectId,
                        orElse: () => MapEntry("", ""),
                      )
                      .key
                  : null;

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
                      value: (selectedProjectName ?? '').isEmpty
                          ? null
                          : selectedProjectName,
                      hint: const Text(
                        "Projet",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.font,
                        ),
                      ),
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down, size: 16),
                      items: projects.entries.map((entry) {
                        return DropdownMenuItem<String>(
                          value: entry.key, // Pass the name as the value
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
                        if (value != null) {
                          String? selectedProjectId = projects[value];
                          context.read<ProjectSelectBloc>().add(
                              ProjectSelectSwitch(value: selectedProjectId!));
                        }
                      },
                    ),
                  ),
                ),
              );
            },
          );
        }

        // Handle loading or empty state
        return const SizedBox();
      },
    );
  }
}
