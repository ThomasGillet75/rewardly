import 'package:flutter/material.dart';

import 'add_button_widget.dart';

class AddProjectWidget extends StatefulWidget {
  const AddProjectWidget({super.key});

  @override
  State<AddProjectWidget> createState() => _AddProjectWidgetState();
}

class _AddProjectWidgetState extends State<AddProjectWidget> {
  final TextEditingController _projectController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: IntrinsicHeight(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
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
              // Important pour limiter la taille verticale au contenu
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEEEEE),
                          border: Border.all(
                            color: const Color(0xFFB7B7B7),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: TextField(
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: "Nom du projet",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      child: const AddButtonWidget(),
                    ),
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
}
