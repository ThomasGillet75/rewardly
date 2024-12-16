import 'package:equatable/equatable.dart';
import 'package:rewardly/Data/models/friendly_entity.dart';
import '../../../Data/models/user_entity.dart';

abstract class FriendsState extends Equatable {
  const FriendsState();

  @override
  List<Object> get props => [];
}

class FriendsInitial extends FriendsState {

}

class FriendsLoading extends FriendsState {}

class FriendsSuccess extends FriendsState {
  final List<Users> friends;

  const FriendsSuccess(this.friends);

  @override
  List<Object> get props => [friends];
}

class FriendsAdded extends FriendsState {
}

class FriendsRemoved extends FriendsState {
  final List <Friendly> friendly;

  const FriendsRemoved(this.friendly);

  @override
  List<Object> get props => [friendly];
}

class FriendsSuccessAdd extends FriendsState {
  final List<Users> friends;

  const FriendsSuccessAdd(this.friends);

  @override
  List<Object> get props => [friends];
}


class FriendsFailure extends FriendsState {
  final String error;

  const FriendsFailure({required this.error});

  @override
  List<Object> get props => [error];
}