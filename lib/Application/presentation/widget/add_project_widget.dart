import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rewardly/Application/bloc/input_add/date_select_bloc.dart';
import 'package:rewardly/Application/bloc/project/project_bloc.dart';
import 'package:rewardly/Application/presentation/widget/add_button_widget.dart';
import 'package:rewardly/Application/presentation/widget/name_input_widget.dart';
import 'package:rewardly/core/color.dart';
import 'package:uuid/uuid.dart';

import '../../../Data/models/project_entity.dart';

class AddProjectWidget extends StatefulWidget {
  const AddProjectWidget({super.key});

  @override
  State<AddProjectWidget> createState() => _AddProjectWidgetState();
}

class _AddProjectWidgetState extends State<AddProjectWidget> {
  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    final Uuid id = const Uuid();

    return  Material(
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      NameInputWidget(
                          placeholder: "Nom du projet", controller: controller),
                      const SizedBox(width: 10),
                      AddButtonWidget(
                        onPressed: () => AddProject(controller, id, context),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      );
  }

  void AddProject(TextEditingController controller, Uuid id, BuildContext context) {
    final inputText = controller.text;
    if (inputText.isNotEmpty) {
      Project project = Project(id: id.v4(), name: inputText);
      context.read<ProjectBloc>().add(AddProjectToDB(project));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Projet ${inputText} ajouté avec succès'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      controller.clear();
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
        msg: "Veuillez donner un nom à votre projet",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
