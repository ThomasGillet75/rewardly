import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/color.dart';

class DescriptionInputWidget extends StatefulWidget {
  const DescriptionInputWidget({Key? key, required this.descriptionController}) : super(key: key);
  final TextEditingController descriptionController;
  @override
  State<DescriptionInputWidget> createState() => _DescriptionInputWidgetState();
}

class _DescriptionInputWidgetState extends State<DescriptionInputWidget> {

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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: TextField(
            controller: widget.descriptionController,
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
    );
  }
}