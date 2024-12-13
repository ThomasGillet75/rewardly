import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rewardly/Application%20Layer/bloc/toggle/toggle_bloc.dart';

class ToggleButtonWidget extends StatefulWidget {
  const ToggleButtonWidget({super.key});

  @override
  State<ToggleButtonWidget> createState() => _ToggleButtonWidgetState();
}

class _ToggleButtonWidgetState extends State<ToggleButtonWidget> {
  bool isMesTachesSelected = true;
  double screenWidth = 0;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return BlocBuilder<ToggleBloc, ToggleState>(
        builder: (context, state) {
          return Container(
            width: 200,
            height: 50,
            margin: const EdgeInsets.only(top: 30, bottom: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Stack(
              children: [
                AnimatedAlign(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  alignment: (state as ToggleInitial).isMesTachesSelected
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Container(
                    width: screenWidth * 0.46,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color(0xFFA8D2A8),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            context
                                .read<ToggleBloc>()
                                .add(ToggleSwitch(value: true)),
                        child: const Center(
                          child: Text(
                            'Mes taches',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            context
                                .read<ToggleBloc>()
                                .add(ToggleSwitch(value: true)),
                        child: const Center(
                          child: Text(
                            'Projet',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
  }
