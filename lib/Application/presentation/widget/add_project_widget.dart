import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rewardly/Application/presentation/widget/add_button_widget.dart';
import 'package:rewardly/Application/presentation/widget/name_input_widget.dart';
import 'package:rewardly/core/color.dart';
import 'package:uuid/uuid.dart';

import '../../../Data/models/project_entity.dart';
import '../../bloc/add/add_bloc.dart';

class AddProjectWidget extends StatefulWidget {
  const AddProjectWidget({super.key});

  @override
  State<AddProjectWidget> createState() => _AddProjectWidgetState();
}

class _AddProjectWidgetState extends State<AddProjectWidget> {
  final Uuid id = const Uuid();

  @override
  Widget build(BuildContext context) {
    final TextEditingController projectController = TextEditingController();

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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                            padding:
                            const EdgeInsets.symmetric(horizontal: 16.0),
                            child: TextField(
                              controller: projectController,
                              autofocus: true,
                              decoration: InputDecoration(
                                hintText: "Nom du projet",
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
                      const SizedBox(width: 10),
                      BlocConsumer<AddBloc, AddState>(
                        listener: (context, state) {
                          if (state is AddSuccess) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Le projet ${projectController.text} a été ajouté avec succès!'),
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
                        builder: (context, state) => ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {
                            if (projectController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Le nom du projet ne peut pas être vide."),
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20), // Ajustez "bottom" selon vos besoins
                                ),
                              );
                            } else {
                              context.read<AddBloc>().add(
                                AddRequested(
                                  project: Project(
                                    name: projectController.text,
                                    id: id.v1(),
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
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
