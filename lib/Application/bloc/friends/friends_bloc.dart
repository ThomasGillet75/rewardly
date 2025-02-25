import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rewardly/Domain/repositories/user_repository.dart';

import '../../../Data/models/user_entity.dart';
import 'friends_event.dart';
import 'friends_state.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  final UserRepository _userRepository = UserRepository();
  FriendsBloc() : super(FriendsInitial()) {
    on<SearchFriends>(_onFriendsRequested);
    on<ResetSearch>(_onResetSearch);
  }

  Future<void> _onFriendsRequested(
      SearchFriends event, Emitter<FriendsState> emit) async {
    emit(FriendsLoading());
    try {
      final List<Users> friends = await _userRepository.getUser(event.pseudo);
      emit(FriendsSuccess(friends));
    } catch (e) {
      emit(FriendsFailure(error: _mapErrorToMessage(e)));
    }
  }

  Future<void> _onResetSearch(
      ResetSearch event, Emitter<FriendsState> emit) async {
    emit(FriendsInitial());

  }

  String _mapErrorToMessage(dynamic error) {
    if (error is String) {
      return error;
    } else {
      return 'Erreur inconnue';
    }
  }
}