import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rewardly/Application/bloc/input_add/date_select_bloc.dart';
import 'package:rewardly/Application/bloc/project_select/project_select_bloc.dart';
import 'package:rewardly/Application/bloc/task/task_bloc.dart';
import 'package:rewardly/Application/presentation/widget/date_select_widget.dart';
import 'package:rewardly/Application/presentation/widget/description_input_widget.dart';
import 'package:rewardly/Application/presentation/widget/name_input_widget.dart';
import 'package:rewardly/Application/presentation/widget/priority_select_widget.dart';
import 'package:rewardly/Application/presentation/widget/project_select_widget.dart';
import 'package:rewardly/core/color.dart';
import 'package:uuid/uuid.dart';
import '../../../Core/task_priority_enum.dart';
import '../../../Data/models/task_entity.dart';
import '../../bloc/priority_select/priority_select_bloc.dart';
import '../../bloc/project/project_bloc.dart';
import 'add_button_widget.dart';

class AddTaskWidget extends StatefulWidget {
  const AddTaskWidget({super.key});

  @override
  State<AddTaskWidget> createState() => _AddTaskWidgetState();
}

class _AddTaskWidgetState extends State<AddTaskWidget> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  TaskPriority? priorityController;
  String? projectController;
  DateTime? _selectedDate = DateTime.now();
  final Uuid id = const Uuid();

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
                      controller: nameController),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  DescriptionInputWidget(
                      descriptionController: descriptionController),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DateSelectWidget(
                      dateController: dateController,
                      selectedDate: _selectedDate!),
                  const SizedBox(width: 10),
                  Expanded(
                      child: PrioritySelectWidget(
                          priorityController: priorityController)),
                  const SizedBox(width: 10),
                  ProjectSelectWidget(projectController: projectController),
                  const SizedBox(width: 10),
                  MultiBlocListener(
                    listeners: [
                      BlocListener<DateSelectBloc, DateSelectState>(
                        listener: (context, dateState) {},
                      ),
                      BlocListener<PrioritySelectBloc, PrioritySelectState>(
                        listener: (context, priorityState) {},
                      ),
                      BlocListener<ProjectBloc, ProjectState>(
                        listener: (context, projectState) {
                          projectController = projectState.projects[0].id;
                        },
                      ),
                    ],
                    child: AddButtonWidget(
                      onPressed: () {
                        final rootContext = Navigator.of(context).context;
                        final dateState = context.read<DateSelectBloc>().state;
                        final priorityState = context.read<PrioritySelectBloc>().state;
                        final projectState = context.read<ProjectSelectBloc>().state;
                        if (checkIsNotEmpty(dateState, priorityState, projectState)) {
                          AddTask(context, nameController, descriptionController, (dateState as DateSelectInitial).selectedDate, (priorityState as PrioritySelectInitial).selectedPriority, (projectState as ProjectSelectInitial).selectedProject);
                          (dateState as DateSelectInitial).selectedDate = null;
                          (priorityState as PrioritySelectInitial).selectedPriority = TaskPriority.none;
                          (projectState as ProjectSelectInitial).selectedProject = "";
                        } else {
                          (dateState as DateSelectInitial).selectedDate = null;
                          (priorityState as PrioritySelectInitial).selectedPriority = TaskPriority.none;
                          (projectState as ProjectSelectInitial).selectedProject = "";
                          Fluttertoast.showToast(
                            msg: "Veuillez remplir tous les champs",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }

  bool checkIsNotEmpty(DateSelectState dateState, PrioritySelectState priorityState, ProjectSelectState projectState) => nameController.text.isNotEmpty &&  descriptionController.text.isNotEmpty && (dateState as DateSelectInitial).selectedDate != null && (priorityState as PrioritySelectInitial).selectedPriority != TaskPriority.none && (projectState as ProjectSelectInitial).selectedProject != "";

  Future<void> AddTask(
    BuildContext context,
    TextEditingController nameController,
    TextEditingController descriptionController,
    DateTime? dateController,
    TaskPriority? priorityController,
    String projectController,
  ) async {
    final inputName = nameController.text;
    final inputDescription = descriptionController.text;
    final inputDate = dateController;
    final inputProject = projectController;

      Task task = Task(
        id: id.v4(),
        name: inputName,
        description: inputDescription,
        deadline: inputDate,
        priority: priorityController!,
        projectId: inputProject,
        isDone: false,
        subTasks: [],
      );

      context.read<TaskBloc>().add(AddTaskToDB(task));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tâche $inputName ajoutée avec succès'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Réinitialisez les champs après l'ajout
      nameController.clear();
      descriptionController.clear();
      dateController = null;

      context.read<PrioritySelectBloc>().add(
            PrioritySelectSwitch(value: TaskPriority.none),
          );
      Navigator.pop(context);
    }
  }
