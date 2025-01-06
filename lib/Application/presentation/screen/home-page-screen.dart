import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rewardly/Application/bloc/project/project_bloc.dart';
import 'package:rewardly/Application/bloc/task/task_bloc.dart';
import 'package:rewardly/Application/bloc/toggle/toggle_bloc.dart';
import 'package:rewardly/Application/presentation/widget/add_task_and_project_widget/add_project_widget.dart';
import 'package:rewardly/Application/presentation/widget/add_task_and_project_widget/add_task_widget.dart';
import 'package:rewardly/Application/presentation/widget/container_filtering_task_widget.dart';
import 'package:rewardly/Application/presentation/widget/friend_widget/icon_friends_button_widget.dart';
import 'package:rewardly/Application/presentation/widget/main_page/toggle_button_widget.dart';
import 'package:rewardly/Application/presentation/widget/add_task_and_project_widget/project_card_widget.dart';
import 'package:rewardly/Application/presentation/widget/task_details_widget.dart';
import 'package:rewardly/Data/models/task_entity.dart';
import 'package:rewardly/main.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key, required this.title});

  final String title;

  @override
  State<HomePageScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomePageScreen> with RouteAware {
  void _showTaskDetails(Task task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) => TaskDetailsWidget(task: task),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    context.read<TaskBloc>().add(GetTasks(_auth.currentUser!.uid));
    context.read<ProjectBloc>().add(GetProjects());
  }

  @override
  void didPopNext() {
    super.didPopNext();
    _fetchData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ModalRoute? modalRoute = ModalRoute.of(context);
    if (modalRoute is PageRoute) {
      routeObserver.subscribe(this, modalRoute);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        //add icon
        actions: const [
          IconFriendButtonWidget(),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: [
          const ToggleButtonWidget(),
          BlocBuilder<ToggleBloc, ToggleState>(
            builder: (context, state) {
              if ((state as ToggleInitial).isMesTachesSelected) {
                return BlocBuilder<TaskBloc, TaskState>(
                  builder: (context, state) {
                    if (state is TaskFailure) {
                      return Center(
                        child: Text('Failed to load tasks: ${state.error}'),
                      );
                    } else if (state is TaskLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is TaskLoaded) {
                      return ContainerFilteringTaskWidget(
                        tasks: state.tasks,
                        onTaskSelected: _showTaskDetails,
                      );
                    } else {
                      return const Center(child: Text('No tasks available'));
                    }
                  },
                );
              } else {
                return BlocBuilder<ProjectBloc, ProjectState>(
                  builder: (context, state) {
                    if (state is ProjectLoaded) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.projects.length,
                        itemBuilder: (context, index) {
                          final project = state.projects[index];
                          final users = state.users;
                          return ProjectCarWidget(
                            project: project,
                            users: users,
                          );
                        },
                      );
                    } else if (state is ProjectFailure) {
                      return Center(
                        child: Text('Failed to load projects: ${state.error}'),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            builder: (context) {
              return BlocBuilder<ToggleBloc, ToggleState>(
                builder: (context, state) {
                  if (state is ToggleInitial && state.isMesTachesSelected) {
                    return FocusScope(
                      onFocusChange: (hasFocus) {
                        if (!hasFocus) FocusScope.of(context).unfocus();
                      },
                      child: const AddTaskWidget(),
                    );
                  } else {
                    return const AddProjectWidget();
                  }
                },
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
