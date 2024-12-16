import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/color.dart';

class NameInputWidget extends StatefulWidget {
  const NameInputWidget({Key? key, required this.placeholder})
      : super(key: key);
  final String placeholder;

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
            controller: _taskController,
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
