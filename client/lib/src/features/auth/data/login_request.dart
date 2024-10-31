import 'dart:convert';
import 'package:converse/src/core/core.dart';

class LoginRequest extends ApiRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'password': password,
    };
  }

  String toJson() => json.encode(toMap());
}
