import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rewardly/Application/bloc/friends/friends_bloc.dart';
import 'package:rewardly/Application/bloc/friends/friends_event.dart';
import 'package:rewardly/Core/color.dart';
import 'package:rewardly/Data/models/friendly_entity.dart';
import 'package:rewardly/Data/models/user_entity.dart';

class FriendCard extends StatefulWidget {
  const FriendCard({super.key, required this.user});
  final Users user;

  @override
  State<FriendCard> createState() => _FriendCardState();
}

class _FriendCardState extends State<FriendCard> {
  bool _isAdded = false;

  void _addFriend(BuildContext context, Friendly friend) {
    context.read<FriendsBloc>().add(AddFriend(friend: friend));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.person, size: 40),
            onPressed: () {
              print("On ajoute");
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.user.pseudo,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(_isAdded ? Icons.check : Icons.add),
            onPressed: () {
              setState(() {
                _isAdded = !_isAdded;
              });
              if (_isAdded) {
                final friend = Friendly(
                  userId: '', // This will be set in the service
                  friendId: widget.user.id,
                );
                _addFriend(context, friend);
              }
            },
          ),
        ],
      ),
    );
  }
}
