part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUpRequested extends SignUpEvent {
 final Users users;

  const SignUpRequested({required this.users});

  @override
  List<Object> get props => [users];
}


