import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rewardly/Data/models/project_model.dart';
import 'package:rewardly/Data/services/firestore_data_service.dart';
import 'package:rewardly/Data/services/firestore_project_members_service.dart';
import 'package:uuid/uuid.dart';

class FirestoreProjectService extends IDataService<ProjectModel> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ProjectMembersService _projectMembersService = ProjectMembersService();

  final Uuid _uuid = const Uuid();

  @override
  Future<void> add(ProjectModel item) async {
    _firestore.collection('projects').doc(_uuid.v4()).set(item.toMap());
  }

  @override
  Future<void> delete(String id) async {
    _firestore.collection('projects').doc(id).delete();
  }

  @override
  Future<ProjectModel> get(String id) {
    return _firestore.collection('projects').doc(id).get().then((doc) {
      return ProjectModel.fromMap(doc.data()!);
    });
  }
Future<Stream<List<ProjectModel>>> getProjectsByUserId(String userId) async {
  final QuerySnapshot projectSnapshot = await _firestore.collection('project_members').where('user_id', isEqualTo: userId).get();
  final List<String> projectIds = projectSnapshot.docs.map((doc) => doc['project_id'] as String).toList();
  final projectStream = _firestore.collection('projects').where('id', whereIn: projectIds).snapshots().map((snapshot) {
    final projects = snapshot.docs.map((doc) => ProjectModel.fromMap(doc.data())).toList();

    for (var project in projects) {
      print('\x1B[34mProject Name: ${project.name}\x1B[0m'); // Blue
      print('\x1B[32mProject ID: ${project.id}\x1B[0m'); // Green
      print('\x1B[33mProject Reward: ${project.reward}\x1B[0m'); // Yellow
    }

    return projects;
  });

  return projectStream;
}

  @override
  Future<void> update(ProjectModel item) async {
    final docRef = _firestore.collection('projects').doc(item.id.trim());

    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      await docRef.update(item.toMap());
    } else {
      throw Exception('Document not found');
    }
  }

  @override
  Stream<List<ProjectModel>> getAll() {
    final projectMembersStream = _projectMembersService
        .getProjectMembersByUserId(_auth.currentUser!.uid);
    return projectMembersStream.asyncExpand((projectMembers) {
      final projectIds =
          projectMembers.map((member) => member.projectId).toList();
      return _firestore
          .collection('projects')
          .where('project_id', whereIn: projectIds)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => ProjectModel.fromMap(doc.data()))
            .toList();
      });
    });
  }
}
