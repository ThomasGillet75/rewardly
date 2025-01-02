import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../Data/models/project_members_entity.dart';


class ProjectMembersService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addMembers(ProjectMembersEntity project) {
    return _firestore.collection('project_members').add(project.toMap());
  }

  Future<List<ProjectMembersEntity>> getProjectMembers(String projectId) async {
    final QuerySnapshot projectSnapshot = await _firestore.collection(
        'project_members').where('project_id', isEqualTo: projectId).get();
    return projectSnapshot.docs.map((doc) =>
        ProjectMembersEntity.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Stream<List<ProjectMembersEntity>> getProjectMembersByUserId(
      String userId)  {
    return _firestore.collection('project_members').where('user_id', isEqualTo: userId).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ProjectMembersEntity.fromMap(doc.data()))
          .toList();
    }
    );
  }

  Stream<List<ProjectMembersEntity>>getAll() {
    return _firestore.collection('project_members').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ProjectMembersEntity.fromMap(doc.data()))
          .toList();
    });
  }

  Future<void> addOwner (String id) {
    return _firestore.collection('project_members').add({
      'project_id': id,
      'user_id': FirebaseAuth.instance.currentUser!.uid,
    });
  }

}