import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rewardly/Domain/repositories/user_repository.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final UserRepository _authService = UserRepository();

  SignInBloc() : super(SignInInitial()) {
    on<SignInRequested>(_onSignInRequested);
  }

  Future<void> _onSignInRequested(
      SignInRequested event, Emitter<SignInState> emit) async {
    emit(SignInLoading());
    try {
      await _authService.signInWithEmail(event.email, event.password);
      emit(SignInSuccess());
    } catch (e) {
      emit(SignInFailure(error: _mapErrorToMessage(e)));
    }
  }

  String _mapErrorToMessage(dynamic error) {
    if (error is String) {
      return error;
    } else {
      return 'Unknown error';
    }
  }
}
