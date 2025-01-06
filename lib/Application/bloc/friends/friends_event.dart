import 'package:equatable/equatable.dart';
import 'package:rewardly/Data/models/friendly_entity.dart';

abstract class FriendsEvent extends Equatable {
  const FriendsEvent();

  @override
  List<Object> get props => [];
}

class SearchInFriends extends FriendsEvent {
  final String pseudo;

  const SearchInFriends({required this.pseudo});

  @override
  List<Object> get props => [pseudo];
}

class SearchFriends extends FriendsEvent {
  final String pseudo;

  const SearchFriends({required this.pseudo});

  @override
  List<Object> get props => [pseudo];
}

class AddFriend extends FriendsEvent {
  final Friendly friend;

  const AddFriend({required this.friend});

  @override
  List<Object> get props => [friend];
}

class GetFriends extends FriendsEvent {
  const GetFriends();

  @override
  List<Object> get props => [];
}

class RemoveFriend extends FriendsEvent {
  final Friendly friend;

  const RemoveFriend({required this.friend});

  @override
  List<Object> get props => [friend];
}

class ResetSearch extends FriendsEvent {
  const ResetSearch();

  @override
  List<Object> get props => [];
}
