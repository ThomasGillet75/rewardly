class Users {
  final String pseudo;
  final String id;
  final String mail;
  final String password;

  Users({
    required this.pseudo,
    required this.id,
    required this.mail,
    required this.password,
  });

  factory Users.fromMap(Map<String, dynamic> data) {
    return Users(
      mail: data['mail_address'] ?? '',
      pseudo: data['pseudo'] ?? '',
      id: data['user_id'] ?? '',
      password: data['password'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mail_address': mail,
      'pseudo': pseudo,
      'user_id': id,
      'password': password,
    };
  }

  static empty() {
    return Users(pseudo: '', id: '', mail: '', password: '');
  }
}
