import 'dart:developer';

import 'package:converse/src/core/data/models/user_model.dart';
import 'package:converse/src/core/providers/database_service_provider.dart';
import 'package:converse/src/core/services/database_service.dart';
import 'package:converse/src/features/auth/logic/providers/auth_service_provider.dart';
import 'package:converse/src/features/auth/logic/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = ChangeNotifierProvider((ref) => UserProvider(
      databaseService: ref.watch(databaseServiceProvider),
      authService: ref.watch(authServiceProvider),
    ));

class UserProvider extends ChangeNotifier {
  final DatabaseService databaseService;
  final AuthService authService;
  UserProvider({
    required this.databaseService,
    required this.authService,
  });
  UserModel user = UserModel.empty();

  void retrieveUserInfo() async {
    try {
      user = await databaseService
          .retrieveUserInfo(FirebaseAuth.instance.currentUser!.email ?? 'null');
    } catch (e) {
      log('Could not retrieve user info, cuz: $e');
    }
  }

  Future<bool> logout() async {
    try {
      await authService.logout();
      user = UserModel.empty();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  void clearUserState() {
    user = UserModel.empty();
  }
}
