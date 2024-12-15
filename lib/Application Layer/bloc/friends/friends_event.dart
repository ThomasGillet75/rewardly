import 'package:equatable/equatable.dart';



abstract class FriendsEvent extends Equatable {
  const FriendsEvent();

  @override
  List<Object> get props => [];
}

class SearchFriends extends FriendsEvent {
  final String pseudo;

  const SearchFriends({required this.pseudo});

  @override
  List<Object> get props => [pseudo];
}

class AddFriend extends FriendsEvent {
  final String friendId;

  const AddFriend({required this.friendId});

  @override
  List<Object> get props => [friendId];
}

class ResetSearch extends FriendsEvent {
  const ResetSearch();

  @override
  List<Object> get props => [];
}