import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rewardly/Data/models/project_model.dart';
import 'package:rewardly/Data/services/firestore_data_service.dart';
import 'package:uuid/uuid.dart';

class FirestoreProjectService extends IDataService<ProjectModel> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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

  @override
  Stream<List<ProjectModel>> getAll() {
    return _firestore.collection('projects').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ProjectModel.fromMap(doc.data()))
          .toList();
    });
  }

  @override
  Future<void> update(ProjectModel item) {
    Map<String,dynamic> project = item.toMap();
    return _firestore
        .collection('projects')
        .doc(project['project_id'])
        .update(project);
  }
}
