import 'package:equatable/equatable.dart';

import '../../../Data/models/user_entity.dart';

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


