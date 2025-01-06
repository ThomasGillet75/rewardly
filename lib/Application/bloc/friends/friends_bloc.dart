import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rewardly/Application/bloc/friends/friends_event.dart';
import 'package:rewardly/Application/bloc/friends/friends_state.dart';
import 'package:rewardly/Data/models/user_entity.dart';
import 'package:rewardly/Domain/repositories/friendly_repository.dart';
import 'package:rewardly/Domain/repositories/user_repository.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  final UserRepository _userRepository = UserRepository();
  final FriendlyRepository _friendlyRepository = FriendlyRepository();

  FriendsBloc() : super(FriendsInitial()) {
    on<SearchFriends>(_onFriendsRequested);
    on<ResetSearch>(_onResetSearch);
    on<AddFriend>(_onAddFriend);
    on<RemoveFriend>(_onRemoveFriend);
    on<GetFriends>(_getFriends);
    on<SearchInFriends>(_onSearchInFriends);
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



  Future<void> _onSearchInFriends(
      SearchInFriends event, Emitter<FriendsState> emit) async {
    emit(FriendsLoading());
    try {
      final List<Users> friends = await _friendlyRepository.searchInFriend(event.pseudo);
      emit(FriendsSuccessAdd(friends));
    } catch (e) {
      emit(FriendsFailure(error: _mapErrorToMessage(e)));
    }
  }

  Future<void> _onResetSearch(
      ResetSearch event, Emitter<FriendsState> emit) async {
    emit(FriendsInitial());
  }

  Future<void> _onAddFriend(AddFriend event, Emitter<FriendsState> emit) async {
    emit(FriendsLoading());
    try {
      await _friendlyRepository.addFriend(event.friend);
      final List<Users> friends = await _friendlyRepository.getUser();

      emit(FriendsSuccessAdd(friends));
    } catch (e) {
      emit(FriendsFailure(error: _mapErrorToMessage(e)));
    }
  }

  Future<void> _getFriends(GetFriends event, Emitter<FriendsState> emit) async {
    emit(FriendsLoading());
    try {
      final List<Users> friends = await _friendlyRepository.getUser();
      emit(FriendsSuccessAdd(friends));
    } catch (e) {
      emit(FriendsFailure(error: _mapErrorToMessage(e)));
    }
  }

  Future<void> _onRemoveFriend(
      RemoveFriend event, Emitter<FriendsState> emit) async {
    emit(FriendsLoading());
    try {
      await _friendlyRepository.removeFriend(event.friend);
      List<Users> friends = await _friendlyRepository.getUser();
      emit( FriendsRemoved( friendly: const [], friends: friends));
    } catch (e) {
      emit(FriendsFailure(error: _mapErrorToMessage(e)));
    }
  }

  String _mapErrorToMessage(dynamic error) {
    if (error is String) {
      return error;
    } else {
      return 'Erreur inconnue';
    }
  }
}
