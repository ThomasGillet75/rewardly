import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/friends/friends_bloc.dart';
import '../../bloc/friends/friends_event.dart';
import '../../bloc/friends/friends_state.dart';
import '../widget/friend_card_widget.dart';
import '../widget/reward_card_widget.dart';

class FriendsPageScreen extends StatefulWidget {
  @override
  _FriendsPageScreenState createState() => _FriendsPageScreenState();
}

class _FriendsPageScreenState extends State<FriendsPageScreen> {
  final TextEditingController pseudoController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    pseudoController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Amis'),
      ),
      body: BlocBuilder<FriendsBloc, FriendsState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            children: [
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Rechercher un ami',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () => _resetSearch(context),
                  ),
                ),
                onChanged: (_) => _searchFriends(context),
              ),
              const SizedBox(height: 16.0),
              if (state is FriendsLoading)
                const Center(child: CircularProgressIndicator())
              else if (state is FriendsSuccess)
                Card(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: state.friends.length,
                    itemBuilder: (context, index) {
                      final friend = state.friends[index];
                      return FriendCard(user: friend);
                    },
                  ),
                )
              else if (state is FriendsFailure)
                  Center(child: Text('Erreur: ${state.error}')),
              const SizedBox(height: 16.0),
            ],
          );
        },
      ),
    );
  }
}