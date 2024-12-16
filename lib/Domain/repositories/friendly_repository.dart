import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Data/models/friendly_entity.dart';
import '../../Data/models/user_entity.dart';
import '../../Data/services/firestore_friendly_service.dart';


class FriendlyRepository {
final fireStoreFriendlyService = FirestoreFriendlyService();

  Future<void> addFriend(Friendly friend) async {
    await fireStoreFriendlyService.addFriend(friend);
  }

  Future<List<Users>> getUser() async {
    return await fireStoreFriendlyService.getUser();
  }

  Future<void> removeFriend(Friendly friend) async {
    await fireStoreFriendlyService.removeFriend(friend);
  }

Future<List<Users>> searchInFriend(String pseudo) async {
   return await fireStoreFriendlyService.searchInFriend(pseudo);
  }

}
