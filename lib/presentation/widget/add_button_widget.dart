import 'package:flutter/material.dart';

class AddButtonWidget extends StatefulWidget {
  const AddButtonWidget({super.key});

  @override
  State<AddButtonWidget> createState() => _AddButtonWidgetState();
}

class _AddButtonWidgetState extends State<AddButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFA8D2A8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: () {print("On ajoute");},
      child: const Icon(Icons.send, color: Colors.black),
    );
  }
}
