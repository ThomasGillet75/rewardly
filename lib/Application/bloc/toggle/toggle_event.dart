part of 'toggle_bloc.dart';

abstract class ToggleEvent extends Equatable {
  const ToggleEvent();

  @override
  List<Object> get props => [];
}

class ToggleSwitch extends ToggleEvent {
  final bool value;

  const ToggleSwitch({required this.value});

  @override
  List<Object> get props => [value];
}