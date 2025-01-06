import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rewardly/Application/bloc/friends/friends_bloc.dart';
import 'package:rewardly/Application/bloc/friends/friends_event.dart';
import 'package:rewardly/Application/bloc/project/project_bloc.dart';
import 'package:rewardly/Application/bloc/project_members/project_member_bloc.dart';
import 'package:rewardly/Data/models/project_entity.dart';
import 'package:rewardly/Data/models/user_entity.dart';
import 'package:rewardly/core/color.dart';

import 'friends_members_widget.dart';

class IconAddFriendButtonWidget extends StatefulWidget {
  const IconAddFriendButtonWidget({
    super.key,
    required this.users,
    required this.project,
  });

  final Map<String, List<Users>> users;
  final Project project;

  @override
  State<IconAddFriendButtonWidget> createState() => _AddButtonWidgetState();
}

class _AddButtonWidgetState extends State<IconAddFriendButtonWidget> {
  final searchController = TextEditingController();

  void _getProjectMembers(BuildContext context) {
    context.read<ProjectMemberBloc>().add(ProjectMemberLoad(widget.project.id));
  }

  void _searchInFriends(BuildContext context) {
    if (searchController.text.isEmpty) {
      _getProjectMembers(context);
    } else {
      context
          .read<ProjectMemberBloc>()
          .add(ProjectMembersSearch(searchController.text));
    }
  }

  void _resetSearch(BuildContext context) {
    searchController.clear();
    context.read<FriendsBloc>().add(const ResetSearch());
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        shadowColor: AppColors.primary.withOpacity(0),
      ),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
          ),
          builder: (context) => _buildBottomSheet(context),
        );
      },
      child: const Icon(Icons.person_add_alt_1),
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        height: 250,
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BlocBuilder<ProjectBloc, ProjectState>(
                  builder: (context, state) {
                    if (state is ProjectLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ProjectLoaded) {
                      final projectUsers = state.users[widget.project.id] ?? [];
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (projectUsers.isEmpty)
                            const Center(child: Text("No users found.")),
                          if (projectUsers.isNotEmpty)
                            _buildUserList(projectUsers),
                          const SizedBox(height: 16.0),
                          _buildAddUserButton(),
                        ],
                      );
                    } else {
                      return const Center(
                        child: Text("Failed to load users."),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddUserButton() {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () {
        // Handle the logic for adding a user to the project
        Navigator.pop(context);
        _getProjectMembers(context);
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          builder: (context) => Column(
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
                onChanged: (value) => _searchInFriends(context),
              ),
              FriendsMembersWidget(project: widget.project),
            ],
          ),
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.person_add),
          SizedBox(width: 8),
          Text("Add user"),
        ],
      ),
    );
  }

  Widget _buildUserList(List<Users> users) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          title: Text(user.pseudo),
          leading: const Icon(Icons.person),
        );
      },
    );
  }
}
