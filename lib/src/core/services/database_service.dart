import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:converse/src/core/data/models/user_model.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  final _db = FirebaseFirestore.instance;

  Future<UserModel> retrieveUserInfo(String email) async {
    try {
      QuerySnapshot response =
          await _db.collection('users').where('email', isEqualTo: email).get();

      return UserModel.fromMap(
          (response.docs[0].data() as Map<String, dynamic>));
    } catch (e) {
      log('Failed to retrieve user info: $e');
      throw e.toString();
    }
  }

  Future<UserModel> addUserToDataBase(
      String username, String email) async {
    try {
      DocumentReference response = await _db.collection('users').add(
            UserModel(
              id: const Uuid().v4(),
              username: username,
              email: email,
            ).toMap(),
          );
      DocumentSnapshot snapshot = await response.get();
      return UserModel.fromMap((snapshot.data() as Map<String, dynamic>));
    } catch (e) {
      log('Failed to add user info to db: $e');
      throw e.toString();
    }
  }
}
