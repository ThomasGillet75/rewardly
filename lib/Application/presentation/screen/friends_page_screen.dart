import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rewardly/Application/bloc/friends/friends_bloc.dart';
import 'package:rewardly/Application/bloc/friends/friends_event.dart';
import 'package:rewardly/Application/bloc/friends/friends_state.dart';
import 'package:rewardly/Application/presentation/widget/friend_widget/add_friend_button_widget.dart';
import 'package:rewardly/Application/presentation/widget/friend_widget/friendly_card_widget.dart';


class FriendsPageScreen extends StatefulWidget {
  const FriendsPageScreen({super.key});

  @override
  _FriendsPageScreenState createState() => _FriendsPageScreenState();
}

class _FriendsPageScreenState extends State<FriendsPageScreen> {
  final TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _getFriends(context);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _getFriends(BuildContext context) {
    context.read<FriendsBloc>().add(const GetFriends());
  }

  void _searchInFriends(BuildContext context) {
    if (searchController.text.isEmpty) {
      _getFriends(context);
    } else {
      context.read<FriendsBloc>().add(SearchInFriends(pseudo: searchController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Amis'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: BlocBuilder<FriendsBloc, FriendsState>(
              builder: (context, state) {
                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  children: [
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Rechercher un ami',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => _getFriends(context)
                        ),
                      ),
                      onChanged: (value) => _searchInFriends(context),
                    ),
                    const SizedBox(height: 16),
                    if (state is FriendsSuccessAdd)
                      Card(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.friends.length,
                          itemBuilder: (context, index) {
                            final friend = state.friends[index];
                            return FriendlyCardWidgetCard(friend: friend); // Ensure friend.user is a Users object
                          },
                        ),
                      )
                      else if(state is FriendsRemoved)
                        Card(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.friends.length,
                            itemBuilder: (context, index) {
                              final friend = state.friends[index];
                              return FriendlyCardWidgetCard(friend: friend); // Ensure friend.user is a Users object
                            },
                          ),
                        )

                    else if (state is FriendsFailure)
                        Center(child: Text('Erreur: ${state.error}')),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: AddFriendButtonWidget(),
    );
  }
}