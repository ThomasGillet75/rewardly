import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rewardly/Application/bloc/project/project_bloc.dart';
import 'package:rewardly/core/color.dart';
import 'package:uuid/uuid.dart';

import '../../../Data/models/project_entity.dart';

class AddButtonWidget extends StatefulWidget {
  final VoidCallback? onPressed;

  const AddButtonWidget({super.key, required this.onPressed});

  @override
  State<AddButtonWidget> createState() => _AddButtonWidgetState();
}

class _AddButtonWidgetState extends State<AddButtonWidget> {
  final Uuid id = const Uuid();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: widget.onPressed,
      child: const Icon(Icons.send, color: Colors.black),
    );
  }
}
