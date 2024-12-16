part of 'add_bloc.dart';

@immutable
sealed class AddState {}

final class AddInitial extends AddState {}

final class AddLoading extends AddState {}

final class AddSuccess extends AddState {}

final class AddFailure extends AddState {
  final String error;

  AddFailure({required this.error});
}
