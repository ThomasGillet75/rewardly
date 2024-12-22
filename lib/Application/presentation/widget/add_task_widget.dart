import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rewardly/Application/bloc/add/add_bloc.dart';
import 'package:rewardly/Application/bloc/project/project_bloc.dart';
import 'package:rewardly/Core/color.dart';
import 'package:rewardly/Core/task_priority_enum.dart';
import 'package:rewardly/Core/utils/task_utils.dart';
import 'package:rewardly/Data/models/task_entity.dart';
import 'package:uuid/uuid.dart';

class AddTaskWidget extends StatefulWidget {
  const AddTaskWidget({super.key});

  @override
  State<AddTaskWidget> createState() => _AddTaskWidgetState();
}

class _AddTaskWidgetState extends State<AddTaskWidget> {


  final TextEditingController controller = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String? priorityController;
  String? projectController;
  DateTime? _selectedDate;
  final Uuid id = const Uuid();
  final List<String> _priorities = [
    TaskUtils.priorityToString(TaskPriority.low),
    TaskUtils.priorityToString(TaskPriority.medium),
    TaskUtils.priorityToString(TaskPriority.high)
  ];
  final List<String> _projects = ['Ecole', 'Maison', 'IOT'];

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
                bottom: MediaQuery
                    .of(context)
                    .viewInsets
                    .bottom,
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                // Nom de la tâche
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.backgroundTextInput,
                          border: Border.all(
                            color: AppColors.borderTextInput,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: TextField(
                            controller: controller,
                            autofocus: true, // Ouvre automatiquement le clavier
                            decoration: InputDecoration(
                              hintText: "Nom de la tâche",
                              border: InputBorder.none,
                              hintStyle: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: AppColors.font,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.backgroundTextInput,
                          border: Border.all(
                            color: AppColors.borderTextInput,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 10),
                          child: TextField(
                            controller: descriptionController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              hintText: "Description de la tâche",
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: AppColors.font,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _selectedDate = pickedDate;
                            dateController.text =
                            "${pickedDate.day}/${pickedDate
                                .month}/${pickedDate
                                .year}";
                          });
                        }
                      },
                      child: Container(
                        height: 48, // Assure une hauteur cohérente
                        decoration: BoxDecoration(
                          color: AppColors.backgroundTextInput,
                          border: Border.all(
                            color: AppColors.borderTextInput,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0), // Alignement
                          child: Align(
                            alignment: Alignment.centerLeft,
                            // Alignement à gauche
                            child: Text(
                              dateController.text.isNotEmpty
                                  ? dateController.text
                                  : "Date",
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.font,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
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
                            value: priorityController,
                            hint: const Text(
                              "Priorité",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.font),
                            ),
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down, size: 16),
                            items: _priorities.map((priority) {
                              return DropdownMenuItem(
                                value: priority.toString(),
                                child: Text(
                                  priority
                                      .toString()
                                      .split('.')
                                      .last,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                priorityController = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    BlocBuilder<ProjectBloc, ProjectState>(
                        builder: (context, state) {
                          return Expanded(
                              child: Container(
                                height: 48,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0),
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
                                    icon: const Icon(
                                        Icons.arrow_drop_down, size: 16),
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
                              )
                          );
                        }),
                    const SizedBox(width: 10),
                    BlocConsumer<AddBloc, AddState>(
                      listener: (context, state) {
                        if (state is AddSuccess) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'La tâche: ${controller
                                      .text} a été ajouté avec succès!'),
                            ),
                          );
                        } else if (state is AddFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.error),
                            ),
                          );
                        }
                      },
                      builder: (context, state) =>
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () {
                              if (controller.text.isEmpty ||
                                  descriptionController.text.isEmpty ||
                                  dateController.text.isEmpty ||
                                  priorityController == null ||
                                  projectController == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "Les champs doivent tous être remplis."),
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.only(bottom: MediaQuery
                                        .of(context)
                                        .viewInsets
                                        .bottom,
                                        left: 20,
                                        right: 20), // Ajustez "bottom" selon vos besoins
                                  ),
                                );
                              } else {
                                context.read<AddBloc>().add(
                                  AddRequested.forTask(
                                    task: Task(
                                      name: controller.text,
                                      description: descriptionController.text,
                                      deadline: _selectedDate!,
                                      priority: priorityController ==
                                          TaskUtils.priorityToString(
                                              TaskPriority.low)
                                          ? TaskPriority.low
                                          : priorityController ==
                                          TaskUtils.priorityToString(
                                              TaskPriority.medium)
                                          ? TaskPriority.medium
                                          : TaskPriority.high,
                                      id: id.v1(),
                                      subTasks: [],
                                      isDone: false,
                                      projectId: '0',
                                    ),
                                  ),
                                );
                              }
                            },
                            child: const Icon(Icons.send, color: Colors.black),
                          ),
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