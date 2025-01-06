import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rewardly/Application/bloc/input_add/date_select_bloc.dart';
import 'package:rewardly/Application/bloc/priority_select/priority_select_bloc.dart';
import 'package:rewardly/Application/bloc/project_select/project_select_bloc.dart';
import 'package:rewardly/Application/bloc/task/task_bloc.dart';
import 'package:rewardly/Application/presentation/widget/date_select_widget.dart';
import 'package:rewardly/Application/presentation/widget/name_input_widget.dart';
import 'package:rewardly/Application/presentation/widget/priority_select_widget.dart';
import 'package:rewardly/Application/presentation/widget/project_select_widget.dart';
import 'package:rewardly/Core/task_priority_enum.dart';
import 'package:rewardly/Data/models/task_entity.dart';
import 'package:rewardly/core/color.dart';
import 'package:uuid/uuid.dart';

import 'add_button_widget.dart';

class AddTaskWidget extends StatefulWidget {
  const AddTaskWidget({super.key});

  @override
  State<AddTaskWidget> createState() => _AddTaskWidgetState();
}

class _AddTaskWidgetState extends State<AddTaskWidget> {
  final TextEditingController nameController = TextEditingController();
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DateSelectWidget(),
                  const SizedBox(width: 10),
                  Expanded(child: PrioritySelectWidget()),
                  const SizedBox(width: 10),
                  ProjectSelectWidget(),
                  const SizedBox(width: 10),
                  MultiBlocListener(
                    listeners: [
                      BlocListener<DateSelectBloc, DateSelectState>(
                        listener: (context, dateState) {},
                      ),
                      BlocListener<PrioritySelectBloc, PrioritySelectState>(
                        listener: (context, priorityState) {},
                      ),
                      BlocListener<ProjectSelectBloc, ProjectSelectState>(
                        listener: (context, projectState) {},
                      ),
                    ],
                    child: AddButtonWidget(
                      onPressed: () {
                        final dateState = context.read<DateSelectBloc>().state;
                        final priorityState =
                            context.read<PrioritySelectBloc>().state;
                        final projectState =
                            context.read<ProjectSelectBloc>().state;
                        if (checkIsNotEmpty(dateState as DateSelectInitial,
                            priorityState, projectState)) {
                          addTask(
                              context,
                              nameController,
                              (dateState).selectedDate,
                              (priorityState as PrioritySelectInitial)
                                  .selectedPriority,
                              (projectState as ProjectSelectInitial)
                                  .selectedProject);
                          resetValue(dateState, priorityState, projectState);
                        } else {
                          resetValue(dateState, priorityState, projectState);
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

  void resetValue(DateSelectInitial dateState,
      PrioritySelectState priorityState, ProjectSelectState projectState) {
    (dateState).selectedDate = null;
    (priorityState as PrioritySelectInitial).selectedPriority =
        TaskPriority.none;
    (projectState as ProjectSelectInitial).selectedProject = "";
    nameController.clear();
  }

  bool checkIsNotEmpty(DateSelectState dateState,
          PrioritySelectState priorityState, ProjectSelectState projectState) =>
      nameController.text.isNotEmpty &&
      (dateState as DateSelectInitial).selectedDate != null &&
      (priorityState as PrioritySelectInitial).selectedPriority !=
          TaskPriority.none &&
      (projectState as ProjectSelectInitial).selectedProject != "";

  Future<void> addTask(
    BuildContext context,
    TextEditingController nameController,
    DateTime? dateController,
    TaskPriority? priorityController,
    String projectController,
  ) async {
    final inputName = nameController.text;
    final inputDate = dateController;
    final inputProject = projectController;

    Task task = Task(
      id: id.v4(),
      name: inputName,
      description: "",
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
    Navigator.pop(context);
  }
}
