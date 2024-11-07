import 'dart:convert';

class User {
  final String id;
  final String email;
  final String username;
  final String avatar;

  User({
    required this.id,
    required this.email,
    required this.username,
    this.avatar = 'default',
  });

  User.empty()
      : id = '',
        email = '',
        username = '',
        avatar = '';

  User copyWith({
    String? id,
    String? email,
    String? username,
    String? avatar,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      avatar: avatar ?? this.avatar,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      if (username.isNotEmpty) 'username': username,
      'avatar': avatar,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? map['userId'] as String,
      email: map['email'] as String,
      username: map['username'] ?? '',
      avatar: map['avatar'] ?? 'default',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, email: $email, username: $username, avatar: $avatar)';
  }
}
