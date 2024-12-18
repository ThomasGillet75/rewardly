import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rewardly/core/color.dart';

class DateSelectWidget extends StatefulWidget{
  DateSelectWidget ({Key? key, required this.dateController, required this.selectedDate}) : super(key: key);
  final TextEditingController dateController;
  DateTime selectedDate;

  @override
  State<DateSelectWidget> createState() => _DateSelectWidgetState();
}

class _DateSelectWidgetState extends State<DateSelectWidget>{

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (pickedDate != null) {
            setState(() {
              widget.selectedDate = pickedDate;
              widget.dateController.text =
              "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
            });
          }
        },
        child: Container(
          height: 48, // Assure une hauteur cohérente
          decoration: BoxDecoration(
            color: AppColors.backgroundTextInput,
            border: Border.all(
              color: AppColors.borderTextInput,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 8.0), // Alignement
            child: Align(
              alignment: Alignment.centerLeft, // Alignement à gauche
              child: Text(
                widget.dateController.text.isNotEmpty
                    ? widget.dateController.text
                    : "Date",
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.font,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}