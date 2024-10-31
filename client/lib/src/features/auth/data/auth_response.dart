import 'dart:convert';
import 'package:converse/src/core/core.dart';

class AuthResponse extends ApiResponse {
  final String id;
  final String email;
  final String username;
  final String token;

  AuthResponse({
    required this.id,
    required this.username,
    required this.email,
    required this.token,
  });

  factory AuthResponse.fromMap(Map<String, dynamic> map) {
    return AuthResponse(
      id: map['data']['userId'] as String,
      email: map['data']['email'] as String,
      username: map['data']['username'] as String,
      token: map['accessToken'] as String,
    );
  }

  factory AuthResponse.fromJson(String source) =>
      AuthResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
