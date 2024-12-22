class Friendly {
  String userId;
  String friendId;

  Friendly({required this.userId, required this.friendId});

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'friend_id': friendId,
    };
  }

  factory Friendly.fromMap(Map<String, dynamic> map) {
    return Friendly(
      userId: map['user_id'],
      friendId: map['friend_id'],
    );
  }
}