


class User {
  String email;
  String password;
  final String id;
  User({
    required this.email,
    required  this.password,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'user_id': id,
    };
  }
}