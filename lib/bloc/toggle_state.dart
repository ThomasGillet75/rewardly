part of 'toggle_bloc.dart';

abstract class ToggleState extends Equatable {
  const ToggleState();

  @override
  List<Object> get props => [];
}

class ToggleInitial extends ToggleState {
  final bool isMesTachesSelected;

  const ToggleInitial(this.isMesTachesSelected);

  @override
  List<Object> get props => [isMesTachesSelected];
}