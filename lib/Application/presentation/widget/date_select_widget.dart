import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rewardly/Application/bloc/input_add/date_select_bloc.dart';
import 'package:rewardly/core/color.dart';

class DateSelectWidget extends StatefulWidget{
  DateSelectWidget ({Key? key}) : super(key: key);
  final TextEditingController dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  State<DateSelectWidget> createState() => _DateSelectWidgetState();
}

class _DateSelectWidgetState extends State<DateSelectWidget>{

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DateSelectBloc, DateSelectState>(
      builder: (context, state) => Container(
          child: GestureDetector(
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: null,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                setState(() {
                  context.read<DateSelectBloc>().add(DateSelectSwitch(value: pickedDate));
                  print("-----------------");
                  print("-----------------");
                  print("-----------------");
                  print("Date : $pickedDate");
                  print("-----------------");
                  print("-----------------");
                  print("-----------------");
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
        )
    );
  }
}