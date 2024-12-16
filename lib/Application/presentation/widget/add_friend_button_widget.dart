import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rewardly/Data/models/friendly_entity.dart';

import '../../bloc/friends/friends_bloc.dart';
import '../../bloc/friends/friends_event.dart';
import '../../bloc/friends/friends_state.dart';
import 'friend_card_widget.dart';

class AddFriendButtonWidget extends StatefulWidget {
  @override
  State<AddFriendButtonWidget> createState() => _AddFriendButtonWidgetState();
}

class _AddFriendButtonWidgetState extends State<AddFriendButtonWidget> {
  final TextEditingController searchController = TextEditingController();

  void _searchFriends(BuildContext context) {
    if (searchController.text.isEmpty) {
      _resetSearch(context);
    } else {
      context.read<FriendsBloc>().add(SearchFriends(pseudo: searchController.text));
    }
  }

  void _resetSearch(BuildContext context) {
    searchController.clear();
    context.read<FriendsBloc>().add(const ResetSearch());
  }



  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
          ),
          builder: (context) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Rechercher un ami',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => _resetSearch(context),
                      ),
                    ),
                    onChanged: (value) => _searchFriends(context),
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<FriendsBloc, FriendsState>(
                    builder: (context, state) {
                      if (state is FriendsLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is FriendsSuccess) {
                        return Card(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.friends.length,
                            itemBuilder: (context, index) {
                              final friend = state.friends[index];
                              return FriendCard(user: friend);
                            },
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
      child: const Icon(Icons.add),
    );
  }
}