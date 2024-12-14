import 'package:equatable/equatable.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUpRequested extends SignUpEvent {
  final String email;
  final String password;
  final String name;

  const SignUpRequested({required this.email, required this.password, required this.name});

  @override
  List<Object> get props => [email, password, name];
}


