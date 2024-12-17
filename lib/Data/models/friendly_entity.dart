class Friendly {
  String user_id;
  String friend_id;

  Friendly({required this.user_id, required this.friend_id});

  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id,
      'friend_id': friend_id,
    };
  }

  factory Friendly.fromMap(Map<String, dynamic> map) {
    return Friendly(
      user_id: map['user_id'],
      friend_id: map['friend_id'],
    );
  }
}