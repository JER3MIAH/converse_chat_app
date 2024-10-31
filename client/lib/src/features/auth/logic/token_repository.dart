// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:converse/src/features/auth/data/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppToken {
  final String? token;
  final User? user;
  AppToken({
    required this.token,
    required this.user,
  });

  AppToken copyWithToken(String? token) {
    return AppToken(
      token: token,
      user: user,
    );
  }

  AppToken copyWithUser(User? user) {
    return AppToken(
      token: token,
      user: user,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'token': token,
      'user': user?.toMap(),
    };
  }

  factory AppToken.fromMap(Map<String, dynamic> map) {
    return AppToken(
      token: map['token'] != null ? map['token'] as String : null,
      user: map['user'] != null
          ? User.fromMap(map['user'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppToken.fromJson(String source) =>
      AppToken.fromMap(json.decode(source) as Map<String, dynamic>);
}

abstract class TokenRepository {
  AppToken getToken();
  Future<bool> saveToken(String token, User user);
  Future<bool> deleteToken();
  Future<bool> updateToken(AppToken token);
  Future<void> clearUser();
}

class TokenRepositoryImpl implements TokenRepository {
  final SharedPreferences prefs;
  TokenRepositoryImpl({
    required this.prefs,
  });

  @override
  AppToken getToken() {
    return _getTokenObjectFromStorage();
  }

  @override
  Future<bool> saveToken(String token, User user) {
    final appToken = AppToken(token: token, user: user);
    return prefs.setString('token', appToken.toJson());
  }

  AppToken _getTokenObjectFromStorage() {
    try {
      final jsonString = prefs.getString('token');
      if (jsonString == null) {
        return AppToken(token: null, user: null);
      }

      final appToken = AppToken.fromJson(jsonString);
      return appToken;
    } catch (err, stack) {
      log(err.toString());
      log(stack.toString());
      return AppToken(token: null, user: null);
    }
  }

  @override
  Future<bool> deleteToken() async {
    return await prefs.remove('token');
  }

  @override
  Future<bool> updateToken(AppToken token) async {
    return await prefs.setString('token', token.toJson());
  }

  @override
  Future<void> clearUser() async {
    await prefs.clear();
    await prefs.reload();
  }
}
