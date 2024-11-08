import 'dart:convert';
import 'package:converse/src/core/core.dart';

class SignUpRequest extends ApiRequest {
  final String username;
  final String email;
  final String avatar;
  final String password;

  SignUpRequest({
    required this.username,
    required this.email,
    required this.avatar,
    required this.password,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'email': email,
      'avatar': avatar,
      'password': password,
    };
  }

  String toJson() => json.encode(toMap());
}
