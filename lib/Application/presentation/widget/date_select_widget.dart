import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rewardly/Application/bloc/input_add/date_select_bloc.dart';
import 'package:rewardly/core/color.dart';

class DateSelectWidget extends StatefulWidget {
  DateSelectWidget({super.key});

  final TextEditingController dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  State<DateSelectWidget> createState() => _DateSelectWidgetState();
}

class _DateSelectWidgetState extends State<DateSelectWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DateSelectBloc, DateSelectState>(
      builder: (context, state) {
        final selectedDate =
            state is DateSelectInitial ? state.selectedDate : null;

        return GestureDetector(
          onTap: () async {
            // Ouvre le sélecteur de date
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
              context
                  .read<DateSelectBloc>()
                  .add(DateSelectSwitch(value: pickedDate));
            }
          },
          child: Container(
            height: 48, // Hauteur cohérente
            decoration: BoxDecoration(
              color: AppColors.backgroundTextInput,
              border: Border.all(
                color: AppColors.borderTextInput,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  selectedDate != null
                      ? "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"
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
        );
      },
    );
  }
}
