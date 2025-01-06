class Users {
  String pseudo;
  String id;
  String mail;
  String password;

  Users({
    required this.pseudo,
    required this.id,
    required this.mail,
    required this.password,
  });

  Users copyWith({
    String? pseudo,
    String? id,
    String? mail,
    String? password,
  }) {
    return Users(
      pseudo: pseudo ?? this.pseudo,
      id: id ?? this.id,
      mail: mail ?? this.mail,
      password: password ?? this.password,
    );
  }

  factory Users.fromMap(Map<String, dynamic> data) {
    return Users(
      mail: data['mail_address'] ?? '',
      pseudo: data['pseudo'] ?? '',
      id: data['user_id'] ?? '',
      password: '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mail_address': mail,
      'pseudo': pseudo,
      'user_id': id,
    };
  }

  static empty() {
    return Users(pseudo: '', id: '', mail: '', password: '');
  }
}
