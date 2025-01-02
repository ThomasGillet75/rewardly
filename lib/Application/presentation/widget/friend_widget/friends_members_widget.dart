import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rewardly/Application/bloc/project_members/project_member_bloc.dart';
import 'package:rewardly/Application/bloc/project_members/project_members_state.dart';
import '../../../../Core/color.dart';
import '../../../../Data/models/project_entity.dart';
import '../../../../Data/models/project_members_entity.dart';
import '../../../../Data/models/user_entity.dart';
import '../../../bloc/project_members/project_memebers_event.dart';

class FriendsMembersWidget extends StatefulWidget {
  const FriendsMembersWidget({super.key, required this.project});

  final Project project;

  @override
  State<FriendsMembersWidget> createState() => _FriendsMembersWidgetState();
}

class _FriendsMembersWidgetState extends State<FriendsMembersWidget> {
  final Map<String, bool> _addedStatus = {}; // Tracks each user's added status.

  void _addProjectMembers(BuildContext context, ProjectMembersEntity user) {
    context.read<ProjectMemberBloc>().add(ProjectMembersCreate(user));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectMemberBloc, ProjectMembersState>(
      builder: (context, state) {
        if (state is ProjectMembersLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is ProjectMembersLoaded) {
          final users = state.projectMembers;
          return _buildUserList(users);
        }
        return const Center(
          child: Text("No members loaded."),
        );
      },
    );
  }




  Widget _buildUserList(List<Users> users) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        final isAdded = _addedStatus[user.id] ?? false;

        return Container(
          margin: const EdgeInsets.only(bottom: 5),
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.person, size: 40),
                onPressed: () {
                  print("User profile tapped for ${user.pseudo}");
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      user.pseudo,
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(isAdded ? Icons.check : Icons.add),
                onPressed: () {
                  setState(() {
                    _addedStatus[user.id] = !isAdded;
                  });
                  if (_addedStatus[user.id] == true) {
                    final projectMember = ProjectMembersEntity(
                      projectId: widget.project.id,
                      userId: user.id,
                    );
                    _addProjectMembers(context, projectMember);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
