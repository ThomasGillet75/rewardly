import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rewardly/Application/bloc/friends/friends_event.dart';
import 'package:rewardly/Data/models/friendly_entity.dart';
import '../../../Data/models/user_entity.dart';
import '../../../core/color.dart';
import '../../bloc/friends/friends_bloc.dart';

class FriendlyCardWidgetCard extends StatefulWidget {
  const FriendlyCardWidgetCard({super.key, required this.friend});
  final Users friend;

  @override
  State<FriendlyCardWidgetCard> createState() => _FriendCardState();
}

class _FriendCardState extends State<FriendlyCardWidgetCard> {
  bool _isAdded = false;

  void _deleteFriend(BuildContext context, Friendly friend) {
    context.read<FriendsBloc>().add(RemoveFriend(friend: friend));
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
                  widget.friend.pseudo,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(_isAdded ? Icons.check : Icons.delete),
            onPressed: () {
              setState(() {
                _isAdded = !_isAdded;
              });
              if (!_isAdded) {
                final friend = Friendly(
                  userId: '', // This will be set in the service
                  friendId: widget.friend.id,
                );
                _deleteFriend(context, friend);
              }
            },
          ),
        ],
      ),
    );
  }
}