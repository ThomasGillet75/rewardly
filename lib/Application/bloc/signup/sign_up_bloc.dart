import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rewardly/Data/models/user_entity.dart';
import 'package:rewardly/Domain/repositories/user_repository.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final UserRepository _userRepository = UserRepository();

  SignUpBloc() : super(SignUpInitial()) {
    on<SignUpRequested>(_onSignUpRequested);
  }

  /// Handler for the `SignUpRequested` event.
  Future<void> _onSignUpRequested(
      SignUpRequested event, Emitter<SignUpState> emit) async {
    emit(SignUpLoading());
    try {
      await _userRepository.signUpWithEmail(event.users);
      emit(SignUpSuccess());
    } catch (e) {
      emit(SignUpFailure(error: _mapErrorToMessage(e)));
    }
  }


  /// Maps errors to user-friendly messages.

  String _mapErrorToMessage(dynamic error) {
    if (error is String) {
      return error;
    } else {
      return 'Erreur inconnue';
    }
  }
}
