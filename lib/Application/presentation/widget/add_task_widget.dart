import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rewardly/Application/bloc/priority_select/priority_select_bloc.dart';
import 'package:rewardly/Application/presentation/widget/date_select_widget.dart';
import 'package:rewardly/Application/presentation/widget/description_input_widget.dart';
import 'package:rewardly/Application/presentation/widget/name_input_widget.dart';
import 'package:rewardly/Application/presentation/widget/priority_select_widget.dart';
import 'package:rewardly/Application/presentation/widget/project_select_widget.dart';
import 'package:rewardly/core/color.dart';
import 'package:uuid/uuid.dart';

import '../../../Core/task_priority_enum.dart';
import '../../../Core/utils/task_utils.dart';
import '../../../Data/models/task_entity.dart';
import '../../bloc/add/add_bloc.dart';
import '../../bloc/project/project_bloc.dart';
import 'add_button_widget.dart';

class AddTaskWidget extends StatefulWidget {
  const AddTaskWidget({Key? key}) : super(key: key);

  @override
  State<AddTaskWidget> createState() => _AddTaskWidgetState();
}

class _AddTaskWidgetState extends State<AddTaskWidget> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String? priorityController;
  String? projectController;
  DateTime? _selectedDate = DateTime.now();
  final Uuid id = const Uuid();
  final List<String> _priorities = [
    TaskUtils.priorityToString(TaskPriority.low),
    TaskUtils.priorityToString(TaskPriority.medium),
    TaskUtils.priorityToString(TaskPriority.high)
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddBloc(),
      child: Material(
        color: Colors.transparent,
        child: IntrinsicHeight(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 16.0,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Row(
                  children: [
                    NameInputWidget(
                      placeholder: "Nom de la tâche",
                      controller: nameController,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    DescriptionInputWidget(
                      descriptionController: descriptionController,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DateSelectWidget(
                      dateController: dateController,
                      selectedDate: _selectedDate!,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                        child: PrioritySelectWidget(
                            priorityController: priorityController)
                    ),
                    const SizedBox(width: 10),
                    BlocBuilder<ProjectBloc, ProjectState>(
                        builder: (context, state) {
                      List<String> _projects = state.projects
                          .map((project) => project.name)
                          .toList();
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
                            value: projectController,
                            hint: const Text(
                              "Projet",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.font),
                            ),
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down, size: 16),
                            items: _projects.map((project) {
                              return DropdownMenuItem(
                                value: project,
                                child: Text(
                                  project,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                projectController = value!;
                              });
                            },
                          ),
                        ),
                      ));
                    }),
                    const SizedBox(width: 10),
                    BlocConsumer<AddBloc, AddState>(
                      listener: (context, addState) {
                        if (addState is AddSuccess) {
                          // Action pour AddBloc
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Tâche ajoutée avec succès!')),
                          );
                        }
                      },
                      builder: (context, addState) {
                        return BlocBuilder<PrioritySelectBloc,
                            PrioritySelectState>(
                          builder: (context, priorityState) {
                            return ElevatedButton(
                              onPressed: () {
                                // Utilisez les états des deux blocs ici
                                if (nameController.text.isEmpty ||
                                    descriptionController.text.isEmpty ||
                                    dateController.text.isEmpty ||
                                    (priorityState as PrioritySelectInitial)
                                        .selectedPriority == null ||
                                    projectController == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Veuillez remplir tous les champs'),
                                    ),
                                  );
                                }
                                context.read<AddBloc>().add(
                                      AddRequested.forTask(
                                        task: Task(
                                          name: nameController.text,
                                          description: descriptionController.text,
                                          deadline: _selectedDate,
                                          priority: (priorityState as PrioritySelectInitial).selectedPriority,
                                          id: id.v1(),
                                          subTasks: [],
                                          isDone: false,
                                          projectId: '0',
                                        ),
                                      ),
                                    );
                              },
                              child: const Icon(Icons.send, color: Colors.black),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
