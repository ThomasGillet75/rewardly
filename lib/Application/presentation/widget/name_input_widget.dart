import 'package:flutter/material.dart';

import '../../../core/color.dart';

class NameInputWidget extends StatefulWidget {
  const NameInputWidget({super.key, required this.placeholder, required this.controller});
  final String placeholder;
  final TextEditingController controller;

  @override
  State<NameInputWidget> createState() => _NameInputWidgetState();
}

class _NameInputWidgetState extends State<NameInputWidget> {
  final TextEditingController _taskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
            controller: widget.controller,
            autofocus: true, // Ouvre automatiquement le clavier
            decoration: InputDecoration(
              hintText: widget.placeholder,
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
    );
  }
}
