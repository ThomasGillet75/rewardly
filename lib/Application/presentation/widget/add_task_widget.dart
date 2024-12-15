import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rewardly/Application/presentation/widget/date_select_widget.dart';
import 'package:rewardly/Application/presentation/widget/description_input_widget.dart';
import 'package:rewardly/Application/presentation/widget/name_input_widget.dart';
import 'package:rewardly/Application/presentation/widget/priority_select_widget.dart';
import 'package:rewardly/Application/presentation/widget/project_select_widget.dart';
import 'package:rewardly/core/color.dart';

import 'add_button_widget.dart';

class AddTaskWidget extends StatefulWidget {
  const AddTaskWidget({Key? key}) : super(key: key);

  @override
  State<AddTaskWidget> createState() => _AddTaskWidgetState();
}

class _AddTaskWidgetState extends State<AddTaskWidget> {
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Nom de la tâche
                Row(
                  children: [
                    NameInputWidget(placeholder: "Nom de la tâche"),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [DescriptionInputWidget()],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: DateSelectWidget(),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: PrioritySelectWidget()),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ProjectSelectWidget(),
                    ),
                    const SizedBox(width: 10),
                    AddButtonWidget(),
                  ],
                ),
                const SizedBox(height: 16), // Marges inférieures
              ],
            ),
          ),
        ),
      ),
    );
  }
}